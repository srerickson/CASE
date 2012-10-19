class EvaluationResult < ActiveRecord::Base;

  belongs_to :bird, :readonly => true
  belongs_to :evaluation_question, :readonly => true

  has_one :evaluation_set, :through => :evaluation_question
  has_many :evaluation_answers, :through => :evaluation_question, :readonly => true

  validates_presence_of :bird, :evaluation_question
  validates_uniqueness_of :bird_id, :scope => [:evaluation_question_id]

  scope :for_evaluation_set, lambda { |i| includes(:evaluation_set).where("evaluation_sets.id in (?)", i) }

  scope :for_question, lambda { |i| where("evaluation_question_id in (?)", i) }
  scope :for_bird, lambda { |i| where("bird_id in (?)", i) }
  scope :not_for_question, lambda { |i| where("evaluation_question_id NOT IN (?)", i) }
  scope :not_for_bird, lambda { |i| where("bird_id NOT IN (?)", i) }
  


  def as_json(options = {})
    super({:include => [:bird]}.merge(options || {}))
  end


  def self.lookup(b_id,q_id)
    EvaluationResult
      .for_question(q_id)
      .for_bird(b_id)
      .first
  end


  # Recalculate results for all questions (q_id = nil) or a range of questions 
  #
  # - q_id can be nil (for all questions), a single id, or an array of ids.
  #
  def self.rebuild(q_id = nil) 

    # will be set to our domain of questions and birds
    qs = nil 
    bs = nil
    
    # all quetions that have been used in evaluations

    all_evaled_questions  = UserEvaluationAnswer.group(:evaluation_question_id).size.keys
    all_evaled_birds = UserEvaluationAnswer.includes(:bird).group("birds.id").size.keys

    # set the domain for the update to ... 

    if q_id.nil?  #  ... all questions, all birds

      qs = all_evaled_questions 
      bs = all_evaled_birds

    else  # ... a question or set of questions and the birds evaluated by that question

      if q_id.is_a? Array
        qs = q_id
      else
        qs = [q_id]
      end

      bs = UserEvaluationAnswer
            .includes(:bird)
            .for_question(qs)
            .group("birds.id")
            .size.keys
    end

    # counts for all (bird/questions/answer) combinations in the result domain
    answer_counts  = UserEvaluationAnswer
                      .includes(:bird)
                      .for_question(qs)
                      .group(["birds.id",:evaluation_question_id,:answer])
                      .size

    # counts for all (bird/questions/answer) combination  - with comments
    comment_counts = UserEvaluationAnswer
                      .with_comment
                      .for_question(qs)
                      .includes(:bird)
                      .group(["birds.id",:evaluation_question_id,:answer])
                      .size

    # (1) Update/Create results

    bs.each do |b|
      qs.each do |q|

        results = {
          "yes_count"    => answer_counts[[ b,q,UserEvaluationAnswer.yes]] || 0,
          "yes_comments" => comment_counts[[b,q,UserEvaluationAnswer.yes]] || 0,
          "no_count"     => answer_counts[[ b,q,UserEvaluationAnswer.no]] || 0,
          "no_comments"  => comment_counts[[b,q,UserEvaluationAnswer.no]] || 0,
          "na_count"     => answer_counts[[ b,q,UserEvaluationAnswer.na]] || 0,
          "na_comments"  => comment_counts[[b,q,UserEvaluationAnswer.na]] || 0,
          "blank_count"  => (answer_counts[[b,q,""]] || 0) + (answer_counts[[b,q,nil]] || 0)
        }
        results["answer_score"] = EvaluationResult.answer_score_from_results(results)

        eval_result_for = {"bird_id" => b, "evaluation_question_id" => q}
        r = EvaluationResult.where(eval_result_for).first()
        if !r
          r = EvaluationResult.new(eval_result_for.merge(results)).save
        else
          r.attributes = r.attributes.merge(results)
          r.save if r.changed?
        end
      end
    end

    # (2) Remove unused results

    EvaluationResult.not_for_bird(all_evaled_birds).each{|r| r.destroy }
    EvaluationResult.not_for_question(all_evaled_questions).each{|r| r.destroy }

  end

  def self.answer_score_from_results(r)
    response_count =  (r["yes_count"] +  r["no_count"] + r["na_count"] + r["blank_count"])
    if response_count == 0
      return 0
    else 
      return Float(r["yes_count"] - r["no_count"])/response_count
    end
  end


end
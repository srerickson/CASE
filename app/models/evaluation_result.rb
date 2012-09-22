class EvaluationResult < ActiveRecord::Base;

  belongs_to :bird, :readonly => true
  belongs_to :evaluation_question, :readonly => true

  has_one :evaluation_set, :through => :evaluation_question
  has_many :evaluation_answers, :through => :evaluation_question, :readonly => true

  validates_presence_of :bird, :evaluation_question
  validates_uniqueness_of :bird_id, :scope => [:evaluation_question_id]

  scope :for_question, lambda { |i| where("evaluation_question_id in (?)", i) }
  scope :for_bird, lambda { |i| where("bird_id in (?)", i) }
  scope :not_for_question, lambda { |i| where("evaluation_question_id NOT IN (?)", i) }
  scope :not_for_bird, lambda { |i| where("bird_id NOT IN (?)", i) }
  
  def self.lookup(b_id,q_id)
    EvaluationResult
      .for_question(q_id)
      .for_bird(b_id)
      .first
  end

  def self.build_all
    #EvaluationResult.all.each{|r| r.destroy}
    answer_counts = UserEvaluationAnswer
                      .includes(:bird)
                      .group(["birds.id",:evaluation_question_id,:answer])
                      .size

    comment_counts = UserEvaluationAnswer
                      .with_comment
                      .includes(:bird)
                      .group(["birds.id",:evaluation_question_id,:answer])
                      .size

    all_bs = UserEvaluationAnswer
              .includes(:bird)
              .group("birds.id")
              .size.keys

    all_qs = UserEvaluationAnswer
              .group(:evaluation_question_id)
              .size.keys

    all_bs.each do |b|
      all_qs.each do |q|
        r = EvaluationResult.where(:bird_id => b, :evaluation_question_id => q).first()
        if !r
          r = EvaluationResult.new(:bird_id => b, :evaluation_question_id => q)
        end
        r.update_attributes({
          :yes_count => answer_counts[[b,q,UserEvaluationAnswer.yes]] || 0,
          :yes_comments => comment_counts[[b,q,UserEvaluationAnswer.yes]] || 0,
          :no_count => answer_counts[[b,q,UserEvaluationAnswer.no]] || 0,
          :no_comments => comment_counts[[b,q,UserEvaluationAnswer.no]] || 0,
          :na_count => answer_counts[[b,q,UserEvaluationAnswer.na]] || 0,
          :na_comments => comment_counts[[b,q,UserEvaluationAnswer.na]] || 0,
          :blank_count => (answer_counts[[b,q,""]] || 0) + (answer_counts[[b,q,nil]] || 0)
        })
      end
    end

    EvaluationResult.not_for_bird(all_bs).not_for_question(all_qs).each{|r| r.destroy() }
  end


end
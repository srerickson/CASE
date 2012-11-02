class EvaluationResultRow 

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :bird, :question, :results, :summary
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end


  def build_summary
    self.summary = {}
    self.summary["yes_count"]   = 0
    self.summary["no_count"]    = 0
    self.summary["na_count"]    = 0
    self.summary["blank_count"] = 0

    results.each do |r|
      next if r.evaluation_question.sub_question
      self.summary["yes_count"]   += r.yes_count
      self.summary["no_count"]    += r.no_count
      self.summary["na_count"]    += r.na_count
      self.summary["blank_count"] += r.blank_count
    end
    self.summary["score"] = EvaluationResult.answer_score_from_results(self.summary)

  end


  # assumes results are sorted by bird, then by question
  def self.build_results_table_by_bird(eval_results)
    result_rows = [] 
    prev_bird_id = nil;

    eval_results.each do |eval_result|
      if eval_result.bird_id == prev_bird_id
        result_rows[-1].results << eval_result
      else
        result_rows << EvaluationResultRow.new({
          :results => [eval_result],
          :bird => eval_result.bird,
        })
      end
      prev_bird_id = eval_result.bird_id
    end
    result_rows.each do |row|
      row.build_summary
    end
    return  result_rows
  end


  # assumes results are sorted by question id, then by bird
  def self.build_results_table_by_question(eval_results)
    result_rows = [] 
    prev_q_id = nil;
    eval_results.each do |eval_result|
      if eval_result.evaluation_question_id == prev_q_id
        result_rows[-1].results << eval_result
      else
        result_rows << EvaluationResultRow.new({
          :results => [eval_result],
          :question => eval_result.evaluation_question,
        })
      end
      prev_q_id = eval_result.evaluation_question_id
    end
    result_rows.each do |row|
      row.build_summary
    end
    return  result_rows
  end





end
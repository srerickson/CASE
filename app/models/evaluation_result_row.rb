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

end
class EvaluationResult < ActiveRecord::Base

  belongs_to :bird
  belongs_to :evaluation_question
  has_one :evaluation_set, :through => :evaluation_question


  scope :for_question, lambda { |i| where("evaluation_question_id in (?)", i) }
  scope :for_bird, lambda { |i| where("bird_id in (?)", i) }
  
  def self.lookup(b_id,q_id)
    EvaluationResult
      .for_question(q_id)
      .for_bird(b_id)
      .first
  end


end
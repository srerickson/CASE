class UserEvaluation < ActiveRecord::Base

  belongs_to :user
  belongs_to :evaluation_set
  belongs_to :bird
  has_many :evaluation_questions, :through => :evaluation_set
  has_many :user_evaluation_answers, :dependent => :destroy
  accepts_nested_attributes_for :user_evaluation_answers
  
  validates_presence_of :user, :evaluation_set, :bird
  validate :unique_user_evalset_bird_triple, :on => :create 
  
  before_create :build_answer_records
  

  def answered_questions
    UserEvaluationAnswer.for_user_evaluation(id).complete_answers
  end

  def unanswered_questions
    UserEvaluationAnswer.for_user_evaluation(id).incomplete_answers
  end

  def description
    "#{evaluation_set.name}: #{bird.name}"
  end

  def complete?
    UserEvaluationAnswer.for_user_evaluation(id).incomplete_answers.size == 0
  end

  private

  def build_answer_records
    self.evaluation_set.evaluation_questions.each do |q|
      self.user_evaluation_answers.build(:evaluation_question => q)
    end
  end


  def unique_user_evalset_bird_triple
    if UserEvaluation.where({:user_id => user_id, :evaluation_set_id => evaluation_set_id, :bird_id => bird_id }).count > 0
       errors.add(:bird_id, "You have already evaluated '#{bird.name}' with evaluation set '#{evaluation_set.name}'")
    end
  end
  
end

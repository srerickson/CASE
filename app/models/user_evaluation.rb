class UserEvaluation < ActiveRecord::Base

  belongs_to :user
  belongs_to :evaluation_set
  belongs_to :bird
  has_many :user_evaluation_answers, :dependent => :destroy
  
  accepts_nested_attributes_for :user_evaluation_answers
  
  validates_presence_of :user, :evaluation_set, :bird  
  
  before_create :build_answer_records
  
  
  def build_answer_records
    self.evaluation_set.evaluation_questions.each do |q|
      self.user_evaluation_answers.build(:evaluation_question => q)
    end
  end

  def description
    "#{evaluation_set.name}: #{bird.name}"
  end
  
end

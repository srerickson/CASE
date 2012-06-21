class UserEvaluation < ActiveRecord::Base

  belongs_to :user
  belongs_to :evaluation_set
  belongs_to :bird

  has_many :user_evaluation_answers
  accepts_nested_attributes_for :user_evaluation_answers
  
  validates_presence_of :user, :evaluation_set, :bird

  
end

class EvaluationSet  < ActiveRecord::Base;


  # An EvaluationSet is a collection of questions 
  has_many :evaluation_questions, :order => "position ASC"
  has_many :evaluation_results, :through => :evaluation_questions
  accepts_nested_attributes_for :evaluation_questions, :allow_destroy => true

  # The questions a related to user answers through user's evaluations
  has_many :user_evaluations
  has_many :user_evaluation_answers, :through => :user_evaluations

  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"

  has_many :birds, :through => :user_evaluations, :uniq => true
  
end

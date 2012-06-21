class EvaluationSet  < ActiveRecord::Base;

  has_many :evaluation_questions, :order => "position ASC"
  has_many :user_evaluations
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"

  accepts_nested_attributes_for :evaluation_questions, :allow_destroy => true

end

class EvaluationQuestion < ActiveRecord::Base

  default_scope  :order => "position ASC"
  
  belongs_to :evaluation_set
  has_many :user_evaluation_answers
  has_many :evaluation_results

  validate :update_on_unlock_only
  before_destroy :destroy_on_unlock_only 



  def to_s
    "#{position}. #{question}"
  end

  private

  def update_on_unlock_only
    if evaluation_set and evaluation_set.locked
      message = "Cannot be changed when the evaluation set is locked"
      errors.add(:position, message) if position_changed?
      errors.add(:question, message) if question_changed?
    end
  end


  def destroy_on_unlock_only 
    if evaluation_set and evaluation_set.locked
      errors.add_to_base("Cannot delete while the evaluation set is locked")
      return false
    end
  end

end

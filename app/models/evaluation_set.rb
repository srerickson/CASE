class EvaluationSet  < ActiveRecord::Base;


  # An EvaluationSet is a collection of questions 
  has_many :evaluation_questions, :order => "position ASC"
  has_many :evaluation_results, :through => :evaluation_questions
  accepts_nested_attributes_for :evaluation_questions, :allow_destroy => true

  # The questions a related to user answers through user's evaluations
  has_many :user_evaluations
  has_many :user_evaluation_answers, :through => :user_evaluations

  # the user who created the evaluation set
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"

  # the birds that have have been evaluated
  has_many :birds, :through => :user_evaluations, :uniq => true

  # the users who have done evaluations based on this set
  has_many :users, :through => :user_evaluations, :uniq => true

  validate :update_on_unlock_only
  before_destroy :destroy_on_unlock_only 

  def results_by_bird
    result_rows = []
    all_questions = self.evaluation_questions.map { |q| q.id }
    self.birds.each do |b|
      qs = EvaluationResult.for_question(all_questions).for_bird(b.id)
      result_rows << EvaluationResultRow.new({:bird => b, :questions => qs})
    end
    result_rows
  end
  
  protected

  def update_on_unlock_only
    if locked
      message = "Cannot be changed when the evaluation set is locked"
      errors.add(:name, message) if name_changed?
      errors.add(:instructions, message) if instructions_changed?
    end
  end

  def destroy_on_unlock_only 
    if locked
      errors.add_to_base("Cannot delete while locked")
      return false
    end
  end


end

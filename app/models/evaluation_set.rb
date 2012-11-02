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
  has_many :birds, :through => :user_evaluations, :uniq => true, :order => "name ASC"

  # the users who have done evaluations based on this set
  has_many :users, :through => :user_evaluations, :uniq => true

  validate :update_on_unlock_only
  before_destroy :destroy_on_unlock_only 



  def self.response_group_for(result_rows)
    answer_keys = [:yes_count, :no_count, :na_count]
    scores = {:yes_count => 1, :no_count => 2, :na_count => 3}
    signature = ""
    result_rows[:questions].each_with_index do |q,i|
      ans_counts = q.reject{|k,v| !answer_keys.include?(k)}
      max_count = ans_counts.max_by{|k,v| v }[1]
      all_max_counts = ans_counts.keep_if{ |k,v| v == max_count }
      score = all_max_counts.size == 1 ? scores[all_max_counts.to_a[0][0]] : 0
      signature[i] = score.to_s
    end 
    return signature
  end


  def response_groups
    groups = {}
    results_by_bird.each do |r|
      group_sig = EvaluationSet.response_group_for(r)
      groups[group_sig] ||= []
      groups[group_sig] << r[:bird]
    end
    return groups.sort_by{|k,v| v.size }.reverse!
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

class AddCommentToUserEvaluation < ActiveRecord::Migration
  def self.up
    add_column :user_evaluations, :comment, :text
  end

  def self.down
    remove_column :user_evaluations, :comment
  end
end

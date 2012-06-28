class AddBirdsField < ActiveRecord::Migration
  def self.up
    add_column :birds, :tangible_problem, :string
    add_column :birds, :tangible_problem_detail, :text
  end

  def self.down
    remove_column :birds, :tangible_problem
    remove_column :birds, :tangible_problem_detail
  end
end

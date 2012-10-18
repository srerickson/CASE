class ChangeResultsCommentsColumnType < ActiveRecord::Migration
  def self.up
    change_column :evaluation_results, :yes_comments, :integer, :default => 0
    change_column :evaluation_results, :no_comments, :integer, :default => 0
    change_column :evaluation_results, :na_comments, :integer, :default => 0
  end

  def self.down
    change_column :evaluation_results, :yes_comments, :text
    change_column :evaluation_results, :no_comments, :text
    change_column :evaluation_results, :na_comments, :text
  end
end

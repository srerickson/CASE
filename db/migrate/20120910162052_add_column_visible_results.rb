class AddColumnVisibleResults < ActiveRecord::Migration
  def self.up
    add_column :evaluation_sets, :visible_results, :boolean, :default => false
  end

  def self.down
    remove_column :evaluation_sets, :visible_results        
  end
end

class AddMetaPaperToEverything < ActiveRecord::Migration
  def self.up
	add_column :comments, :get_paper_id, :integer
	add_column :questions, :get_paper_id, :integer
	add_column :votes, :get_paper_id, :integer
	add_column :figsections, :get_paper_id, :integer
	add_column :assertions, :get_paper_id, :integer	
  	add_index :comments, :get_paper_id
  	add_index :questions, :get_paper_id
  	add_index :votes, :get_paper_id
  	add_index :figsections, :get_paper_id
  	add_index :assertions, :get_paper_id
  	add_index :shares, :get_paper_id
  	add_index :sumreqs, :get_paper_id
  end

  def self.down
	remove_column :comments, :get_paper_id
	remove_column :questions, :get_paper_id
	remove_column :votes, :get_paper_id
	remove_column :figsections, :get_paper_id
	remove_column :assertions, :get_paper_id	
  	remove_index :shares, :get_paper_id
  	remove_index :sumreqs, :get_paper_id

  end
end

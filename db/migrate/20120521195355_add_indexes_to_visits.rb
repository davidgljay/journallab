class AddIndexesToVisits < ActiveRecord::Migration
  def self.up
	add_index :visits, :user_id
	add_index :visits, :paper_id
  end

  def self.down
	remove_index :visits, :user_id
	remove_index :visits, :paper_id
  end
end

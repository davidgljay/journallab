class AddAssertionIdToComments < ActiveRecord::Migration
  def self.up
     add_column :comments, :assertion_id, :integer
  end

  def self.down
     remove_column :comment, :assertion_id
  end
end

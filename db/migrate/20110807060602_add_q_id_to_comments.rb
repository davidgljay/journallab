class AddQIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :question_id, :integer
  end

  def self.down
   remove_column :comments, :question_id
  end
end

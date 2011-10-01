class AddPublicBooleanToStuff < ActiveRecord::Migration
  def self.up
    add_column :assertions, :is_public,  :boolean
    add_column :questions, :is_public,  :boolean
    add_column :comments, :is_public,  :boolean
  end

  def self.down
    remove_column :assertions, :is_public
    remove_column :questions, :is_public
    remove_column :comments, :is_public
  end
end

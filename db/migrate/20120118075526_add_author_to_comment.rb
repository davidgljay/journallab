class AddAuthorToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :author, :boolean
    add_column :questions, :author, :boolean
  end

  def self.down
    remove_column :comments, :author
    remove_column :questions, :author
  end
end

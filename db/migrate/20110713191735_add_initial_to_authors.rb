class AddInitialToAuthors < ActiveRecord::Migration
  def self.up
    add_column :authors, :initial, :text
  end

  def self.down
    remove_column :authors, :initial
  end
end

class ChangeNameToFirstAndLast < ActiveRecord::Migration
  def self.up
     add_column :users, :lastname, :string
     rename_column :users, :name, :firstname
  end

  def self.down
     remove_column :users, :lastname
     rename_column :users, :firstname, :name
  end
end

class AddProfileInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :image_uid, :string
    add_column :users, :image_name, :string
    add_column :users, :homepage, :string
    add_column :users, :cv, :string
    add_column :users, :position, :string
    add_column :users, :institution, :string
  end

  def self.down
    remove_column :users, :institution
    remove_column :users, :position
    remove_column :users, :cv
    remove_column :users, :homepage
    remove_column :users, :image_name
    remove_column :users, :image_uid
  end
end

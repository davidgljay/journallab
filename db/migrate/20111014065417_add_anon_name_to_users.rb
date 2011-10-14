class AddAnonNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :anon_name, :string
    add_column :users, :specialization, :text
    add_column :users, :profile_link, :string
  end

  def self.down
    remove_column :users, :anon_name
    remove_column :users, :specialization
    remove_column :users, :profile_link
  end
end

class AddTypeToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :form, :string
  end

  def self.down
    remove_column :comments, :form
  end
end

class AddCodeToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :code, :string
  end

  def self.down
    remove_column :groups, :code
  end
end

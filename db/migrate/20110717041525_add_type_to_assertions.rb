class AddTypeToAssertions < ActiveRecord::Migration
  def self.up
    add_column :assertions, :about, :string
  end

  def self.down
    remove_column :assertions, :about
  end
end

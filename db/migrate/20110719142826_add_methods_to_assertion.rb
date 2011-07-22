class AddMethodToAssertion < ActiveRecord::Migration
  def self.up
    add_column :assertions, :method, :text
  end

  def self.down
    remove_column :assertions, :method
  end
end

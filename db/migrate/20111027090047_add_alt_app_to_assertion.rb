class AddAltAppToAssertion < ActiveRecord::Migration
  def self.up
    add_column :assertions, :alt_approach, :text
  end

  def self.down
    remove_column :assertions, :alt_approach
  end
end

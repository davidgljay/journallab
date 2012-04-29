class RenameMethodInAssertions < ActiveRecord::Migration
  def self.up
	rename_column :assertions, :method, :method_text
  end

  def self.down
	rename_column :assertions, :method_text, :method
  end
end

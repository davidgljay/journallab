class AddAnonymityToAssertions < ActiveRecord::Migration
  def change
    add_column :assertions, :anonymous, :boolean
  end
end

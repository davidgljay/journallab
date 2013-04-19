class AddDescription < ActiveRecord::Migration
  def change
    add_column :analyses, :description, :string
  end
end

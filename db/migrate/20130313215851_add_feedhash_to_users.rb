class AddFeedhashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :feedhash, :text
  end
end

class AddOrientationhashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :orientationhash, :text
  end
end

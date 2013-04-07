class AddItemsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :image_name, :string
    add_column :groups, :image_uid, :string
    add_column :groups, :urlname, :string
    add_column :groups, :recent_discussions, :text
  end
end

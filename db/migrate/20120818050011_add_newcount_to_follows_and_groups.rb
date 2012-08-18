class AddNewcountToFollowsAndGroups < ActiveRecord::Migration
  def up
    add_column :follows, :newcount, :integer, :default => 0
    add_column :groups, :newcount, :integer, :default => 0
  end

  def down
    remove_column :follows, :newcount
    remove_column :groups, :newcount
  end
end

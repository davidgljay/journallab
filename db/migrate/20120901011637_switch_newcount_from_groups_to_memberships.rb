class SwitchNewcountFromGroupsToMemberships < ActiveRecord::Migration
  def change
	add_column :memberships, :newcount, :integer
	remove_column :groups, :newcount
  end

  def down
	add_column :groups, :newcount, :integer
	remove_column :memberships, :newcount
  end
end

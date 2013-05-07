class AddRecentDiscussionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recent_discussions, :text
  end
end

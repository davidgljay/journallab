class AddLatestSearchToFollow < ActiveRecord::Migration
  def self.up
    add_column :follows, :latest_search, :text
  end

  def self.down
    remove_column :follows, :latest_search
  end
end

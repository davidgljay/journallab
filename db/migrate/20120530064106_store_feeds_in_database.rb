class StoreFeedsInDatabase < ActiveRecord::Migration
  def self.up
	add_column :groups, :feed, :text
	add_column :groups, :most_viewed, :text
  end

  def self.down
	add_column :groups, :feed
	add_column :groups, :most_viewed
  end
end

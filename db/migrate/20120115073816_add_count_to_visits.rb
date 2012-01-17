class AddCountToVisits < ActiveRecord::Migration
  def self.up
    add_column :visits, :count, :integer
  end

  def self.down
    remove_column :visits, :count
  end
end

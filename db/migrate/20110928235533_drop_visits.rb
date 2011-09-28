class DropVisits < ActiveRecord::Migration
  def self.up
    drop_table :visits
  end

  def self.down
  end
end

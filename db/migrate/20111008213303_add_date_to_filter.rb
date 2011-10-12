class AddDateToFilter < ActiveRecord::Migration
  def self.up
    add_column :filters, :date, :timestamp
  end

  def self.down
    remove_column :filters, :date
  end
end

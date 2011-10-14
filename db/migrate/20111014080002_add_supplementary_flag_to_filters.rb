class AddSupplementaryFlagToFilters < ActiveRecord::Migration
  def self.up
   add_column :filters, :supplementary, :boolean
  end

  def self.down
   remove_column :filters, :supplementary
  end
end

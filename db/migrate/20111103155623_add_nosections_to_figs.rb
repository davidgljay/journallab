class AddNosectionsToFigs < ActiveRecord::Migration
  def self.up
    add_column :figs, :nosections, :boolean
  end

  def self.down
    remove_column :figs, :nosections
  end
end

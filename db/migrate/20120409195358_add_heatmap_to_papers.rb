class AddHeatmapToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :h_map, :text
  end

  def self.down
    remove_column :papers, :h_map
  end
end

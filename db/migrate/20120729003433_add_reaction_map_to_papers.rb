class AddReactionMapToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :reaction_map, :text
  end

  def self.down
    remove_column :papers, :reaction_map
  end
end

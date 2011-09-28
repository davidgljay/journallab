class AddImagesToFigs < ActiveRecord::Migration
  def self.up
    add_column :figs, :image_uid,  :string
    add_column :figs, :image_name, :string
  end

  def self.down
    remove_column :figs, :image_uid
    remove_column :figs, :image_name
  end
end

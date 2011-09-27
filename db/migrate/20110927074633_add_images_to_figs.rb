class AddImagesToFigs < ActiveRecord::Migration
  def self.up
    add_column :figs, :image_uid,  :string
    add_column :figs, :image_name, :string
  end

  def self.down
    drop_column :figs, :image_uid
    drop_column :figs, :image_name
  end
end

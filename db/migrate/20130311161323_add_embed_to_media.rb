class AddEmbedToMedia < ActiveRecord::Migration
  def change
    add_column :media, :embed, :text
  end
end

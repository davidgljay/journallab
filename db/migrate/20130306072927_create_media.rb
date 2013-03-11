class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer :user_id
      t.integer :paper_id
      t.text :link
      t.string :category

      t.timestamps
    end
  end
end

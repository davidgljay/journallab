class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.integer :about_id
      t.string :about_type
      t.text :text
      t.integer :folder_id
      t.timestamps
    end
  end
end

class CreateAnon < ActiveRecord::Migration
  def up
    create_table :anons do |t|
      t.string  :name
      t.integer :paper_id
      t.integer :user_id
      t.timestamps
    end

    remove_column :users, :anon_name
  end

  def down
    add_column :users, :anon_name, :string
    drop_table :anon
  end
end

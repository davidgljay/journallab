class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :text
      t.integer :user_id
      t.integer :paper_id
      t.integer :fig_id
      t.integer :figsection_id
      t.integer :comment_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

class CreateReactions < ActiveRecord::Migration
  def self.up
    create_table :reactions do |t|
      t.string  :name
      t.integer :about_id
      t.string  :about_type
      t.integer :user_id
      t.integer :comment_id
      t.integer :get_paper_id

      t.timestamps
    end

  end

  def self.down
    drop_table :reactions
  end
end

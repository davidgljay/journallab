class CreateCommentnotices < ActiveRecord::Migration
  def change
    create_table :commentnotices do |t|
      t.integer :follow_id
      t.integer :comment_id
      t.integer :paper_id
      t.datetime :comment_date

      t.timestamps
    end

    add_index :commentnotices, :follow_id
  end
end

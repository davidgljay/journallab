class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :assertion_id
      t.integer :comment_id
      t.integer :question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
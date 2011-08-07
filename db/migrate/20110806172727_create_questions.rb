class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.text :text
      t.integer :paper_id
      t.integer :fig_id
      t.integer :figsection_id
      t.integer :user_id
      t.integer :assertion_id
      t.integer :question_id
      t.integer :votes

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end

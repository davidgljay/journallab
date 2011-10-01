class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.integer :group_id
      t.integer :paper_id
      t.integer :comment_id
      t.integer :question_id
      t.integer :assertion_id
      t.integer :state

      t.timestamps
    end
  end

  def self.down
    drop_table :filters
  end
end

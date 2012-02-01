class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.integer :paper_id
      t.integer :fig_id
      t.integer :figsection_id
      t.integer :meta_paper_id
      t.integer :user_id
      t.integer :group_id
      t.text :text
      t.integer :tone

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end

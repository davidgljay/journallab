class CreateSumreqs < ActiveRecord::Migration
  def self.up
    create_table :sumreqs do |t|
      t.integer :paper_id
      t.integer :fig_id
      t.integer :figsection_id
      t.integer :get_paper_id
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sumreqs
  end
end

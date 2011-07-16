class CreateFigs < ActiveRecord::Migration
  def self.up
    create_table :figs do |t|
      t.integer :paper_id
      t.integer :num

      t.timestamps
    end
  end

  def self.down
    drop_table :figs
  end
end

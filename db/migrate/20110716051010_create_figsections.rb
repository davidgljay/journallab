class CreateFigsections < ActiveRecord::Migration
  def self.up
    create_table :figsections do |t|
      t.integer :fig_id
      t.integer :num

      t.timestamps
    end
  end

  def self.down
    drop_table :figsections
  end
end

class CreateMaillogs < ActiveRecord::Migration
  def self.up
    create_table :maillogs do |t|
      t.string :purpose
      t.integer :user_id
      t.integer :about_id
      t.string :about_type
      t.datetime :conversiona
      t.datetime :conversionb

      t.timestamps
    end
  end

  def self.down
    drop_table :maillogs
  end
end

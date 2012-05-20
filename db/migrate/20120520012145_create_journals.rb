class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.text :name
      t.string :feedurl
      t.string :url
      t.boolean :open

      t.timestamps
    end
  end

  def self.down
    drop_table :journals
  end
end

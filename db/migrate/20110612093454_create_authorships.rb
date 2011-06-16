class CreateAuthorships < ActiveRecord::Migration
  def self.up
    create_table :authorships do |t|
      t.integer :paper_id
      t.integer :author_id

      t.timestamps
    end
    add_index :authorships, :paper_id
    add_index :authorships, :author_id
    add_index :authorships, [:paper_id, :author_id], :unique => true
  end

  def self.down
    drop_table :authorships
  end
end

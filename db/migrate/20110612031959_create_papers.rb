class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.text :title
      t.integer :pubmed_id
      t.text :journal
      t.text :abstract, :default => ""
      t.text :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :papers
  end
end

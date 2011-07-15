class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.string :title
      t.string :pubmed_id
      t.string :journal
      t.string :abstract, :default => ""
      t.string :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :papers
  end
end

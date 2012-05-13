class AddFirstAndLastAuthorsToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :first_last_authors, :text
  end

  def self.down
    remove_column :papers, :first_last_authors
  end
end

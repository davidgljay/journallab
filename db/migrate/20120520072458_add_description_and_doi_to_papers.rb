class AddDescriptionAndDoiToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :description, :text
    add_column :papers, :doi, :string
  end

  def self.down
    remove_column :papers, :doi
    remove_column :papers, :description
  end
end

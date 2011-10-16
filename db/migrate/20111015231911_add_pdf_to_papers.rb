class AddPdfToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :pdf_link, :string
  end

  def self.down
    remove_column :papers, :pdf_link
  end
end

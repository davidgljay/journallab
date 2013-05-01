class AddPmidIndexToPapers < ActiveRecord::Migration
  def change
    add_index :papers, :pubmed_id
  end
end

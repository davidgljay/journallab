class AddPubdateToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :pubdate, :datetime
  end

  def self.down
    remove_column :papers, :pubdate
  end
end

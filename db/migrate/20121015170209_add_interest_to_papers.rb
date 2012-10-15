class AddInterestToPapers < ActiveRecord::Migration
  def change
    add_column :papers, :interest, :integer
  end
end

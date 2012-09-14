class AddCitationToPapers < ActiveRecord::Migration
  def change
    add_column :papers, :citation, :text
  end
end

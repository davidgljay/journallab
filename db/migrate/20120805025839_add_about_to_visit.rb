class AddAboutToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :about_id, :integer
    add_column :visits, :about_type, :string
  end
end

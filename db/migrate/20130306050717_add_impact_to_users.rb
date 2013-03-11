class AddImpactToUsers < ActiveRecord::Migration
  def change
    add_column :users, :impact, :string
  end
end

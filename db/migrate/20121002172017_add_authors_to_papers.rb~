class AddAuthorsToPapers < ActiveRecord::Migration
  def change
    add_column :papers, :authors, :text
    drop_table :authors
    drop_table :authorships
    remove_column :papers, :first_last_authors
  end
end

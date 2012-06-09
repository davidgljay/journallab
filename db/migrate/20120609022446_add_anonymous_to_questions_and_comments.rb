class AddAnonymousToQuestionsAndComments < ActiveRecord::Migration
  def self.up
	add_column :comments, :anonymous, :boolean
	add_column :questions, :anonymous, :boolean
  end

  def self.down
	remove_column :comments, :anonymous
	remove_column :questions, :anonymous

  end
end

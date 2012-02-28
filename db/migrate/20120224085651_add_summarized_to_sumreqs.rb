class AddSummarizedToSumreqs < ActiveRecord::Migration
  def self.up
    add_column :sumreqs, :summarized, :boolean
  end

  def self.down
    remove_column :sumreqs, :summarized
  end
end

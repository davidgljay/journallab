class AddLatestIssueToJournal < ActiveRecord::Migration
  def self.up
    add_column :journals, :latest_issue, :text
  end

  def self.down
    remove_column :journals, :latest_issue
  end
end

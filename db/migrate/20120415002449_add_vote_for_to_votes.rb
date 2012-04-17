class AddVoteForToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :vote_for_id, :integer
  end

  def self.down
    remove_column :votes, :vote_for_id
  end
end

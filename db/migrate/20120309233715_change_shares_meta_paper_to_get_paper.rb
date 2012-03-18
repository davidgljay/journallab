class ChangeSharesMetaPaperToGetPaper < ActiveRecord::Migration
  def self.up
     rename_column :shares, :meta_paper_id, :get_paper_id
  end

  def self.down
     rename_column :shares, :get_paper_id, :meta_paper_id
  end
end

class RemoveSummaryFromPapers < ActiveRecord::Migration
  def self.up
     change_table :papers do |t|
        t.remove :summary
     end
  end

  def self.down
     change_table :papers do |t|
        t.text :summary
     end
  end
end

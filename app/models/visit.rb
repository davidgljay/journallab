class Visit < ActiveRecord::Base

   after_initialize :init

belongs_to :user
belongs_to :paper

validates :user_id,  :presence => true
validates :paper_id, :presence => true
validates_uniqueness_of :user_id, :scope => [:paper_id]

  def init
    count ||= 0
  end

end

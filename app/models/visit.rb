class Visit < ActiveRecord::Base

belongs_to :user
belongs_to :paper

validates :user_id,  :presence => true
validates :paper_id, :presence => true
validates_uniqueness_of :user_id, :scope => [:paper_id]

end

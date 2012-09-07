class Membership < ActiveRecord::Base

belongs_to :user, :class_name => "User"
belongs_to :group, :class_name => "Group"
has_many :visits, :as => :about, :dependent => :destroy, :order => 'created_at DESC'


validates :user_id, :presence => true
validates :group_id, :presence => true
validates_uniqueness_of :user_id, :scope => [:group_id]

before_save :set_newcount

def set_newcount
	if group.category == 'jclub' && group.current_discussion
		disco = group.current_discussion
		p = disco.paper
		lastvisit = visits.empty? ? Date.new(1900,1,1) : visits.first.created_at 
		self.newcount = p.meta_comments.select{|c| c.created_at > lastvisit}.count
		if disco.starttime > lastvisit
			self.newcount += 1
		end
	else
		self.newcount = 0
	end
	self.newcount
end

end

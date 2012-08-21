class Follow < ActiveRecord::Base

serialize :latest_search

belongs_to :user
has_many :visits, :as => :about, :dependent => :destroy, :order => 'created_at DESC'
belongs_to :follow, :polymorphic => true

validates :name, :presence => true

before_save :update_feed
before_save :set_newcount

def classname
	"follow_" + id.to_s
end

def inspect
	'follow' + id.to_s
end

def feed
	feed = []
	latest_search.each do |p|
		feed << Paper.find(p)
	end
	feed
end


def update_feed
	if search_term
		self.latest_search = Paper.new.search_pubmed(search_term,40).map{|p| p.id}
	end
	latest_search
end

def set_newcount
	lastvisit = visits.empty? ? Date.new(1900,1,1) : visits.first.created_at 
	self.newcount = feed.select{|p| p.created_at > lastvisit}.count
	self.newcount
end

end

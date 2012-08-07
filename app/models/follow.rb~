class Follow < ActiveRecord::Base

serialize :latest_search

belongs_to :user
has_many :visits, :as => :about, :dependent => :destroy
belongs_to :follow, :polymorphic => true

validates :name, :presence => true

def classname
	"follow_" + id.to_s
end

def inspect
	name
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
	self.save
	latest_search
end

end

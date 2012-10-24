class Follow < ActiveRecord::Base

serialize :latest_search

belongs_to :user
has_many :visits, :as => :about, :dependent => :destroy, :order => 'created_at DESC'
belongs_to :follow, :polymorphic => true

validates :name, :presence => true

#before_save :update_feed
before_save :set_newcount

def classname
	"follow_" + id.to_s
end

def inspect
	'follow' + id.to_s
end

def feed
	if latest_search
		latest_search.map{|p| p[0]}		
	else
		Paper.new.search_pubmed(search_term)
	end
end


def update_feed
	if search_term
		pubmed_search = Paper.new.search_pubmed(search_term,40).map{|p| [p, p[:latest_activity]]}
		activity_search = Paper.new.search_activity(search_term).map{|p| [p, p[:latest_activity]]}
		self.latest_search = (pubmed_search + activity_search).sort{|x,y| y[1] <=> x[1]}
	end
	self.save
	self.latest_search
end

def set_newcount
	if latest_search
		lastvisit = self.visits.empty? ? Date.new(1900,1,1) : self.visits.first.created_at 
		self.newcount = Paper.new.pubmed_search_count(search_term, lastvisit)
		self.newcount
	else
		self.newcount = Paper.new.pubmed_search_count(search_term)
	end
end

# Create a set of temporary follows for the homepage
# Returns an array with one follow and several search terms

def create_temp(temp_follows_string)
	temp_follows_array = temp_follows_string.split(",").each{|t| t.strip!}
	follow_array = []	
	temp_follows_array.each do |f|
		 follow_array << Follow.create(:name => f, :search_term => f)
	end
	follow = follow_array.first
	follow_array.delay.each {|f| f.update_feed; f.save;}
	follow_array
end


end

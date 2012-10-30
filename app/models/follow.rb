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

def update_all_feeds
	Follow.all.select{|f| f.user.nil? }.each{|f| f.update_feed}
end

def set_newcount
	if latest_search
		lastvisit = self.visits.empty? ? Date.new(1900,1,1) : self.visits.first.created_at 
		newcount = latest_search.select{|p| p[1] > lastvisit}.count
		if newcount == 40 #Pubmed search results gives an inaccurate number of search results, when the number is low count the results manually in JLab (this is inconvenient for large #s.
			newcount = Paper.new.pubmed_search_count(search_term, lastvisit)			
		end
		self.newcount = newcount
	else
		self.newcount = Paper.new.pubmed_search_count(search_term)
	end
end

def activity_count
	lastvisit = self.visits.empty? ? Date.new(1900,1,1) : self.visits.first.created_at
	papers = Paper.find(:all, :conditions => ['(UPPER(title) LIKE ? or UPPER(abstract) LIKE ?) AND latest_activity >= ?', "%" + self.search_term.upcase + "%", "%" + self.search_term.upcase + "%", lastvisit]) 
	papers = papers.select{|p| p.heatmap}.select{|p| p.h_map[p.inspect][1] > 0}
	comment_papers = Paper.joins('INNER JOIN "comments" ON "papers"."id" = "comments"."get_paper_id"').where('(UPPER("comments"."text") LIKE '"'%" + search_term.upcase + "%'" + ') AND "comments"."created_at" >= '+ "'" + lastvisit.to_s + "'")
	summary_papers = Paper.joins('INNER JOIN "assertions" ON "papers"."id" = "assertions"."get_paper_id"').where("(UPPER(assertions.text) LIKE '%#{search_term.upcase}%' OR UPPER(assertions.method_text) LIKE '%#{search_term.upcase}%') AND assertions.created_at >= '#{lastvisit.to_s}'")
	(papers + comment_papers + summary_papers).uniq.count
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

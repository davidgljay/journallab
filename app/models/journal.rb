class Journal < ActiveRecord::Base

serialize :latest_issue

has_many :follows, :as => :follow

validates :name, :presence => true, :uniqueness => true
validates :feedurl, :presence => true, :uniqueness => true

def feed
	feed = []
	latest_issue.each do |p|
		feed << Paper.find(p)
	end
	feed
end

def classname
	"journal_" + name.gsub(' ','+')
end

def update_feed
	feed = []
	# Create papers in the database for each item in the feed if they don't already exist
	latest_and_greatest.each do |a|
		p = Paper.find_or_create_by_doi(a[:doi])
		p.title = a[:title]
		p.description = a[:description]
		p.abstract = a[:abstract]
		p.pubdate = a[:pubdate]
		p.journal = name
		p.save
		if p.authors.empty?
			a[:authors].each do |authorname|
				namearray = authorname.split(' ')
				author = Author.new
				firstname = author.firstname = namearray[0]
				lastname = author.lastname = namearray[-1]
				initial = author.initial = namearray[1] if namearray.length > 2
		       		if author.save
         				p.authors << author
       				else
          				auth = Author.find(:last, :conditions=> {:firstname => firstname, :lastname => lastname})  
					if !p.authors.include?(auth) 
            					p.authors << auth
					end
          			end	
       			end
			p.assign_first_and_last_authors
		end
		feed << p
	end
	self.latest_issue = feed.map{|p| p.id}
	self.save
	self.latest_issue
  end

# Grab RSS feed for the appropriate Journal

def latest_and_greatest
	latest = []
	xml = Paper.new.openxml(feedurl)
	# Nature
	if feedurl == "http://feeds.nature.com/NatureLatestResearch"
		xml.css('item').each do |article|
			a = {}
			a[:title] = article.css('title').text
			a[:doi] =  article.attribute('about').text[18..-1]
			a[:abstract] = article.css('description').text
			a[:authors] = []
			if !article.xpath("a:creator", {"a" => "http://purl.org/dc/elements/1.1/"}).empty?
				article.xpath("a:creator", {"a" => "http://purl.org/dc/elements/1.1/"}).each do |author|
					a[:authors] << author.text
				end
			end
			a[:pubdate] = article.xpath("a:date", {"a" => "http://purl.org/dc/elements/1.1/"}).text.to_time
			latest << a
		end
	end
	

	latest
  end
end

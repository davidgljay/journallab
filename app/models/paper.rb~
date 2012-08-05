class Paper < ActiveRecord::Base
require 'rexml/document'
require 'nokogiri'
require 'open-uri'

serialize :h_map
serialize :first_last_authors
serialize :reaction_map

#Associations
has_many :authorships, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :authors, :through => :authorships, :source => :author, :order => "authorships.created_at ASC"
has_many :assertions, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :figs, :dependent => :destroy, :order => "figs.num ASC"
has_many :questions, :dependent => :destroy
has_many :visits, :dependent => :destroy
has_many :shares, :dependent => :destroy
has_many :meta_shares, :class_name => "Share"
has_many :sumreqs, :dependent => :destroy
has_many :meta_sumreqs, :class_name => "Sumreq", :foreign_key => "get_paper_id"
has_many :meta_comments, :class_name => "Comment", :foreign_key => "get_paper_id"
has_many :meta_questions, :class_name => "Question", :foreign_key => "get_paper_id"
has_many :meta_votes, :class_name => "Vote", :foreign_key => "get_paper_id"
has_many :meta_assertions, :class_name => "Assertion", :foreign_key => "get_paper_id"
has_many :filters, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :groups, :through => :filters, :source => :group
has_many :meta_reactions, :class_name => "Reaction", :foreign_key => "get_paper_id"
has_many :reactions, :as => :about

#Validations
   validates :pubmed_id, :uniqueness => true, :allow_nil => true
   validates :doi, :uniqueness => true , :allow_nil => true
   validates_numericality_of :pubmed_id, :only_integer => true,
                         :less_than => 9999999999999,
                         :greater_than => 0, :allow_nil => true

before_save :set_reaction_map

def inspect
	'paper' + id.to_s
end


def search_pubmed(search, numresults = 20)
	cleansearch = search.gsub(/[' ']/, "+").gsub(/['.']/, "+").delete('"').delete("'")

# Non-alphanumerics are apprently verboden on heroku,,.gsub(/['α']/, "alpha").gsub(/['β']/, "beta").gsub(/['δ']/, "delta").gsub(/['ε']/, "epsilon").gsub(/['ζ']/, "zeta").gsub(/['θ']/, "theta").gsub(/['ι']/, "iota").gsub(/['κ']/, "kappa").gsub(/['λ']/, "lamda").gsub(/['μ']/, "mu").gsub(/['ν']/, "nu").gsub(/['ξ']/, "xi").gsub(/['ο']/, "omicron").gsub(/['π']/, "pi").gsub(/['ρ']/, "rho").gsub(/['Σσς']/, "sigma").gsub(/['Ττ']/, "tau").gsub(/['Υυ']/, "upsilon").gsub(/['Φφ']/, "phi").gsub(/['Χχ']/, "chi").gsub(/['Ψψ']/, "psi").gsub(/['Ωω']/, "omega")

      	#Get a list of pubmed IDs for the search terms
      	url1 = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=' + cleansearch + '&retmax=' + numresults.to_s
      	pids = Nokogiri::XML(open(url1)).xpath("//IdList/Id").map{|p| p.text} * ","
      	url2 = pids.empty? ? 'http://www.google.com' : 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' + pids + '&retmode=xml&rettype=abstract'
      	data = Nokogiri::XML(open(url2)) 
      	search_results = []
      	data.xpath('//PubmedArticle').each do |article|
        	pid = article.xpath('MedlineCitation/PMID').text
        	paper = Paper.find_by_pubmed_id(pid)
        	if paper.nil?
	        	title = article.xpath('MedlineCitation/Article/ArticleTitle').text
	        	journal = article.xpath('MedlineCitation/Article/Journal/Title').text
	        	day = article.xpath('MedlineCitation/DateCreated/Day').text.to_i
	        	month = article.xpath('MedlineCitation/DateCreated/Month').text.to_i
	        	year = article.xpath('MedlineCitation/DateCreated/Year').text.to_i
			pubdate = Time.local(year, month, day) if year
	        	abstract = article.xpath('MedlineCitation/Article/Abstract/AbstractText').text
        		paper = Paper.create!(:pubmed_id => pid, :title => title, :journal => journal, :pubdate => pubdate, :abstract => abstract)
		end

		# Just pull the authors for now, it takes too much time to save them to the DB (though this could happen once we have a job server.)
		if paper.authors.empty?
			authors = []
			authorlist = article.xpath('MedlineCitation/Article/AuthorList')
			authorlist.xpath('Author').each do |a|
				firstname = a.xpath('ForeName').text 
				lastname = a.xpath('LastName').text
				initials = a.xpath('Initials').text
				authors << Author.new(:firstname => firstname, :lastname => lastname, :initial => initials)
			end
			paper.assign_first_and_last_authors(authors.first, authors.last)
			#paper.extract_authors(data.xpath('//Article/AuthorList')[i])
		else
			authors = paper.authors
		end
        	search_results << paper    
	end
	search_results
  end
	

def lookup_info
  url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' + self.pubmed_id.to_s + '&retmode=xml&rettype=abstract'
  #Check to see if the ID showed up on pubmed, if not return to the homepage.
  data = Nokogiri::XML(open(url))
  if data.xpath("/").empty?
     flash = { :error => "This Pubmed ID is not valid." }
     self.destroy
  else
    self.title = data.xpath('//Article/ArticleTitle').text
    self.journal = data.xpath('//Journal/Title').text
    day = data.xpath('//PubDate/Day').text.to_i == 0 ? nil : data.xpath('//PubDate/Day').text.to_i
    self.pubdate = Time.local(data.xpath('//PubDate/Year').text.to_i, self.monthhash[data.xpath('//PubDate/Month').text], day )
    unless data.xpath('//Abstract/AbstractText').empty?
      self.abstract = data.xpath('//Abstract/AbstractText').text
    end
    self.save
  end
end

#Derive authors
def extract_authors(authorlist = nil)
	if authorlist.nil?
		url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' + pubmed_id.to_s + '&retmode=xml&rettype=abstract'
    		data = Nokogiri::XML(open(url))
    		authorlist = data.xpath('//AuthorList')
	end
	authorlist.xpath('Author').each do |a|
		firstname = a.xpath('ForeName').text 
		lastname = a.xpath('LastName').text
		initials = a.xpath('Initials').text
		a =  Author.new(:firstname => firstname, :lastname => lastname, :initial => initials)
       		if a.save
          		self.authors << a
       		else 
          		auth = Author.find(:last, :conditions=> {:firstname => firstname, :lastname => lastname})  
          		if !self.authors.include?(auth) 
            			self.authors << auth
          		end
       		end
     	end               
end

def assign_first_and_last_authors(f_author = nil, l_author = nil)
	if f_author.nil?
		f_author = authors.first
	end
	if l_author.nil?
		l_author = authors[-1]
	end
	if f_author && l_author	
		f = {:firstname => f_author.firstname, :lastname => f_author.lastname, :name => f_author.lastname + ', ' + f_author.firstname }
		l = {:firstname => l_author.firstname, :lastname => l_author.lastname, :name => l_author.lastname + ', ' + l_author.firstname} 
		self.first_last_authors = [f, l]
		self.save
	end
end

def openxml(source)
	Nokogiri::XML(open(source))
end


def count_figs
  url = 'http://www.ncbi.nlm.nih.gov/pubmed/' + self.pubmed_id.to_s
  doc = Nokogiri::HTML(open(url))
  imagearray = []
  doc.css('img').each do |img|
    if img.attributes.has_key?("src-large")
      imagearray << img.attributes["src-large"].to_s
    end
  end
  self.build_figs(imagearray.count)
  self.delay.grab_figs(doc)
end

def grab_figs(doc)
  #
  #Slightly more liberal, extract images if it's free on PMC.
  #

  if doc.css('a.status_icon').text == "Free PMC Article"
  pmcid = doc.css('dl.rprtid dd').children[2].text.gsub(/([PMC])/, '')
  unless pmcid == ' '
    url2 = 'http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.gov:' + pmcid
    oai = Nokogiri::HTML(open(url2)) unless pmcid.empty?
    	unless oai.css('error').attribute("code").value == "idDoesNotExist"
    		imagearray.count.times do |n|
      			self.figs[n].image_url = "http://www.ncbi.nlm.nih.gov/" + imagearray[n]
      			self.figs[n].save
    		end 
  	end
  end
end
end

#Grab images
def grab_images
  url = 'http://www.ncbi.nlm.nih.gov/pubmed/' + self.pubmed_id.to_s
  doc = Nokogiri::HTML(open(url))
  imagearray = []
  doc.css('img').each do |img|
    if img.attributes.has_key?("src-large")
      imagearray << img.attributes["src-large"].to_s
    end
  end
  self.build_figs(imagearray.count)
  imagearray.count.times do |n|
    self.figs[n].image_url = "http://www.ncbi.nlm.nih.gov/" + imagearray[n]
    self.figs[n].save
  end 
end  

def monthhash
   monthhash = {
      'Jan' => 1,
      'Feb' => 2,
      'Mar' => 3,
      'Apr' => 4,
      'May' => 5,
      'Jun' => 6,
      'July' => 7,
      'Aug' => 8,
      'Sep' => 9,
      'Oct' => 10,
      'Nov' => 11,
      'Dec' => 12
      }
end

#Map reactions to the overall paper and to individual figures and figure sections and store it as a hash text, that way we don't have to run a ton of SQL queries every time the page loads

def set_reaction_map
	rm = {}
	rm[self.inspect] = add_reaction_defaults(check_reactions(self))
	figs.each do |f|
		rm[f.inspect] = add_reaction_defaults(check_reactions(f))
		f.figsections.each do |s|
			rm[s.inspect] = add_reaction_defaults(check_reactions(s))
		end
	end
	self.reaction_map = rm
	reaction_map
end

#Wipe and reset the reaction map

def reset_reaction_map
	reaction_map = nil
	set_reaction_map
end

#Check to see what reactions an object has had and record them to the reaction map

def check_reactions(object)
	if object.class == Fig
		fig_reactions = []
		fig_reactions << object.reactions
		object.figsections.each{|s| s.reactions << fig_reactions}
		reactions.map{|r| [r.name, object.reactions.select{|r2| r2.name == r.name}.count]}.uniq
	else
		object.reactions.map{|r| [r.name, object.reactions.select{|r2| r2.name == r.name}.count]}.uniq
	end
end


#Add default reactions. In the future these should live in some central language file.

def add_reaction_defaults(reacts)
	defaults = Reaction.new.defaults
	defaults.each {|d| reacts << [d,0] unless reacts.map{|o| o[0]}.include?(d)}
	reacts
end

#Generate a version of the reaction map w/out the defaults for analysis purposes

def remove_zero_reactions
	nonzero = {}
	reaction_map.keys.each do |obj|
		nonzero[obj] = reaction_map[obj].select{|r| r[1] > 0}
	end
	nonzero
end	

#Map how much discussion is going on in each part of the paper.
def heatmap
    if h_map.nil?
      heatmap = {}
      heatmap["paper" + id.to_s] = [heat]
      figs.each do |fig|
        heatmap["fig" + fig.id.to_s] = [fig.heat]
        fig.figsections.each do |s|
          heatmap["figsection" + s.id.to_s] = [s.heat]
        end
      end
      calc_heat(heatmap)     
    end
    h_map
end  

#Calculate the relative heat of each element, with 0 being cool and 100 being warm

def calc_heat(heatmap)
   #Find the maximum number of comments
   max = heatmap.values.map{|h| h[0]}.max
   if max == 0
     max = 1
   end
   #Indicate everything else as a percentage
   heatmap.each do |id, h|
     h = h[0]
     float = h.to_f/max * 10
     heatmap[id] = [h, float.to_i]
   end
   self.h_map = heatmap
   self.save     
   self.h_map
end

def add_heat(item)
    self.h_map[item.class.to_s.downcase + item.id.to_s][0] += 1
    calc_heat(self.h_map)
end

def heat
   heat = comments.count
   heat += questions.count
   heat += assertions.count
   heat += reactions.count
   comments.each do |c|
     heat += c.comments.count
   end
   questions.each do |q|
     heat += q.questions.count
     heat += q.comments.count
   end
   heat
end

def heatmap_overview
	max_sections = (figs.map{|f| f.figsections.count}).max.to_i
	overview = [[['Paper', heatmap['paper' + id.to_s][1], 'paper' + id.to_s]] + [nil] * max_sections]
	figs.sort{|x,y| x.num <=> y.num}.each do |fig|
		figrow = [['Fig ' + fig.num.to_s, heatmap['fig' + fig.id.to_s][1], 'fig' + fig.id.to_s]]
		fig.figsections.each do |section|
			figrow << [fig.num.to_s + section.letter, heatmap['figsection' + section.id.to_s][1], 'figsection' + section.id.to_s]
		end
		overview << figrow + [nil] * (max_sections - fig.figsections.count)
	end
	overview
end

def reset_heatmap
	self.h_map = nil
	self.save
	heatmap
end


def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.sort!{|x,y| x.votes.count <=> y.votes.count}
     assert_list.last
end


def meta_latest_assertions
	asserts = [latest_assertion]
	figs.each do |f| 
		asserts << f.latest_assertion
		f.figsections.each do |s|
			asserts << s.latest_assertion
		end
	end
end


def get_paper
    self
end

def shortname
    "the overall paper"
end

def longname
    title
end

def num
    nil
end



def short_abstract
  unless self.abstract.length < 300
    short_abstract = self.abstract[0..150] + " ... " + self.abstract[-150...-1] + "." 
  else
  self.abstract
  end
end

def build_figs(numfigs)
   	newfigs = numfigs.to_i-self.figs.count
	if newfigs > 0
   		newfigs.times do |i|
     			self.figs.create(:num => (self.figs.count+1))
   		end
		reset_heatmap
	elsif newfigs < 0
		(newfigs * -1).times do		
			f = self.figs[-1]
			if f.comments.empty? && f.figsections.empty? && f.questions.empty? && f.assertions.empty? && f.shares.empty?
				f.destroy
			end
			self.reload
		end
	end
   	numfigs
end

# This is a function for quickly building a paper from the console and for testing purposes.
def buildout(struct)
    struct.length.times do |i|
       if i == 0
          self.build_figs(struct[i])
       else
           self.figs[i-1].build_figsections(struct[i])
       end
    end
    reset_heatmap
    struct
end


# Return the highest-ranking group that a user is part of which includes this paper.
def get_group(user)
   maxfilter = 0
   bestgroup = nil
   self.groups.each do |g|
     if g.users.include?(user) && g.filter_state(self) > maxfilter
        maxfilter = g.filter_state(self)
        bestgroup = g
     end
   end
   bestgroup
end

def is_public
   true
end

def jquery_target
   '#paper' + id.to_s
end

#Check to see if the paper is supplementary reading for a given class

def supplementary?(group)
  if f = self.filters.find_by_group_id(group.id)
    f.supplementary
  else
    false
  end
end
  

end

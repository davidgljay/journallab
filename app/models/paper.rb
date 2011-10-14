class Paper < ActiveRecord::Base
require 'rexml/document'
require 'nokogiri'
require 'open-uri'

#Links
has_many :authorships, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :authors, :through => :authorships, :source => :author
has_many :assertions, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :figs, :dependent => :destroy
has_many :questions, :dependent => :destroy
has_many :visits, :dependent => :destroy

has_many :filters, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :groups, :through => :filters, :source => :group


#Validations
   validates :pubmed_id, :presence => true,
                         :uniqueness => true
   validates_numericality_of :pubmed_id, :only_integer => true,
                         :less_than => 9999999999999,
                         :greater_than => 0

def lookup_info
  url = 'http://www.ncbi.nlm.nih.gov/pubmed/' + self.pubmed_id.to_s + '?report=xml'
  dirty_xml = Net::HTTP.get_response(URI.parse(url)).body
  clean_xml = CGI::unescapeHTML(dirty_xml).gsub(/\n/," ").gsub(/>\s*</, "><")
  clean_xml.gsub!(/[&]/, 'and')
  #Check to see if the ID showed up on pubmed, if not return to the homepage.
  data = REXML::Document.new(clean_xml)
  if data.root.elements["PubmedArticle"].nil?
     flash = { :error => "This Pubmed ID is not valid." }
     self.destroy
  else
    article = data.root.elements["PubmedArticle"].elements["MedlineCitation"].elements["Article"]
    extract_data(article)
    extract_authors(article)
  end
end


def extract_data(article)
  self.title = article.elements["ArticleTitle"].text
  self.journal = article.elements["Journal"].elements["Title"].text
  unless article.elements["Abstract"].nil?
    self.abstract = article.elements["Abstract"].elements["AbstractText"].text
  end
  self.save
  article
end

def extract_authors(article)
#Derive authors
  if self.authors.empty?
    all_authors = Author.all.map{|auth| [auth.firstname, auth.lastname, auth.initial, auth.id]} 
    article.elements["AuthorList"].each do |auth|
       author = [auth.elements["ForeName"].text, auth.elements["LastName"].text, auth.elements["Initials"].text]
       if all_authors.map{|auth| [auth[0], auth[1], auth[2]]}.include?(author)
          auth_id = all_authors[all_authors.index{|a| a[0]==author[0] && a[1]==author[1] && a[2]==author[2]}][3]
          Author.find(auth_id).authorships.create(:paper => self)
        else
           self.authors.create(:firstname => author[0], :lastname => author[1], :initial => author[2])
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

#Map how much discussion is going on in each part of the paper.
def heatmap
    heatmap = []
    heatmap << ["paper", id, heat]
    figs.each do |fig|
      heatmap << ["fig", fig.id, fig.heat]
      fig.figsections.each do |s|
         heatmap << ["figsection", s.id, s.heat]
      end
    end
    max = heatmap.map{|h| h[2]}.max
    if max == 0
      max += 1
    end
    heatmap.each do |h|
      if h[2] > 0
         a = 1
      else
         a = 0
      end
      float = h[2].to_f/max * 9 + a
      h[3] = float.to_i
    end       
    heatmap
end  

def heat
   heat = comments.count
   heat += questions.count
   comments.each do |c|
     heat += c.comments.count
   end
   questions.each do |q|
     heat += q.questions.count
   end
   heat
end

def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.last
end

def get_paper
    self
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
   newfigs.times do |i|
     self.figs.create(:num => (self.figs.count+1))
   end
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

end

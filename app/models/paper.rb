class Paper < ActiveRecord::Base
require 'rexml/document'

#Links
has_many :authorships, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :authors, :through => :authorships, :source => :author
has_many :assertions
has_many :comments
has_many :figs

#Validations
   validates :pubmed_id, :presence => true,
                         :length => { :maximum => 12 },
                         :uniqueness => true

def lookup_info
  url = 'http://www.ncbi.nlm.nih.gov/pubmed/' + self.pubmed_id.to_s + '?report=xml'
  dirty_xml = Net::HTTP.get_response(URI.parse(url)).body
  clean_xml = CGI::unescapeHTML(dirty_xml).gsub(/\n/," ").gsub!(/>\s*</, "><")  
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
          Author.find(auth_id).authorships.create(self)
        else
           self.authors.create(:firstname => author[0], :lastname => author[1], :initial => author[2])
       end
     end               
  end
end

#Need to find a way to avoid reproducing this code in Paper, Figs, and Fig sections...
def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.last
end

def short_abstract
  unless self.abstract.length < 500
    short_abstract = self.abstract[0..250] + " ... " + self.abstract[-250...-1] + "." 
  else
  self.abstract
  end
end

def build_figs(numfigs)
   numfigs.to_i.times do |i|
     self.figs.create(:num => (self.figs.count+1))
   end
end

end


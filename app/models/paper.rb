class Paper < ActiveRecord::Base
require 'rexml/document'

has_many :authorships, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :authors, :through => :authorships, :source => :author

#Validations
   validates :pubmed_id, :presence => true,
                         :length => { :is => 8 },
                         :uniqueness => true

def lookup_info
  url = 'http://www.ncbi.nlm.nih.gov/pubmed/' + self.pubmed_id + '?report=xml'
  dirty_xml = Net::HTTP.get_response(URI.parse(url)).body
  clean_xml = CGI::unescapeHTML(dirty_xml).gsub(/\n/," ").gsub!(/>\s*</, "><")
  data = REXML::Document.new(clean_xml)
  article = data.root.elements["PubmedArticle"].elements["MedlineCitation"].elements["Article"]
  self.title = article.elements["ArticleTitle"].text
  self.journal = article.elements["Journal"].elements["Title"].text
  unless article.elements["Abstract"].elements["AbstractText"].nil?
    self.abstract = article.elements["Abstract"].elements["AbstractText"].text
  end

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
 self.save
 end
end


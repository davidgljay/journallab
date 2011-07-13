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
  clean_xml = CGI::unescapeHTML(dirty_xml)
  data = REXML::Document.new(clean_xml)
  article = data.root.elements["PubmedArticle"].elements["MedlineCitation"].elements["Article"]
  self.title = article.elements["ArticleTitle"].text
  self.journal = article.elements["Journal"].elements["ISOAbbreviation"].text
  unless article.elements["Abstract"].elements["AbstractText"].nil?
    self.abstract = article.elements["Abstract"].elements["AbstractText"].text
  end
  self.save
end

end

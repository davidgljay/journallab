class Paper < ActiveRecord::Base
require 'rexml/document'
require 'nokogiri'
require 'open-uri'

serialize :h_map

#Associations
has_many :authorships, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :authors, :through => :authorships, :source => :author
has_many :assertions, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :figs, :dependent => :destroy
has_many :questions, :dependent => :destroy
has_many :visits, :dependent => :destroy
has_many :shares, :dependent => :destroy
has_many :meta_shares, :class_name => "Share"
has_many :sumreqs, :dependent => :destroy
has_many :meta_sumreqs, :class_name => "Sumreq", :foreign_key => "get_paper_id"
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
def extract_authors
    url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' + pubmed_id.to_s + '&retmode=xml&rettype=abstract'
    data = Nokogiri::XML(open(url))
    data.xpath('//AuthorList/Author').each do |auth|
     author = [auth.xpath('ForeName').text, auth.xpath('LastName').text, auth.xpath('Initials').text]
       a = Author.new(:firstname => author[0], :lastname => author[1], :initial => author[2])
       if a.save
          self.authors << a
       else 
          auth = Author.find(:last, :conditions=> {:firstname => author[0], :lastname => author[1]})  
          if !self.authors.include?(auth) 
            self.authors << auth
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
     float = h.to_f/max * 100
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
     assert_list.sort!{|x,y| x.votes.count <=> y.votes.count}
     assert_list.last
end

def get_paper
    self
end

def shortname
    "Overall Paper"
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
   newfigs.times do |i|
     self.figs.create(:num => (self.figs.count+1))
   end
   self.h_map = nil
   self.save
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
    self.h_map = nil
    self.save
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
   'tr#paper'
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

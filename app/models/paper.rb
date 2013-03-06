class Paper < ActiveRecord::Base
  require 'rexml/document'
  require 'nokogiri'
  require 'open-uri'

  serialize :h_map
  serialize :authors
  serialize :reaction_map

#Associations
  has_many :assertions, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :figs, :dependent => :destroy, :order => "figs.num ASC"
  has_many :questions, :dependent => :destroy
  has_many :visits, :as => :about, :dependent => :destroy
  has_many :shares, :dependent => :destroy
  has_many :meta_shares, :class_name => "Share"
  has_many :sumreqs, :dependent => :destroy
  has_many :meta_sumreqs, :class_name => "Sumreq", :foreign_key => "get_paper_id"
  has_many :meta_comments, :class_name => "Comment", :foreign_key => "get_paper_id"
  has_many :meta_questions, :class_name => "Question", :foreign_key => "get_paper_id"
  has_many :meta_votes, :class_name => "Vote", :foreign_key => "get_paper_id"
  has_many :meta_assertions, :class_name => "Assertion", :foreign_key => "get_paper_id"
  has_many :discussions, :foreign_key => "paper_id",
           :dependent => :destroy
  has_many :groups, :through => :discussions, :source => :group
  has_many :meta_reactions, :class_name => "Reaction", :foreign_key => "get_paper_id"
  has_many :reactions, :as => :about
  has_many :anons
  has_many :notes, :as => :about

#Validations
  validates :pubmed_id, :uniqueness => true, :allow_nil => true
  validates :doi, :uniqueness => true , :allow_nil => true
  validates_numericality_of :pubmed_id, :only_integer => true,
                            :less_than => 9999999999999,
                            :greater_than => 0, :allow_nil => true
  before_save :set_reaction_map
  before_save :set_latest_activity
  after_save :check_info


  def inspect
    'paper' + id.to_s
  end

  def to_hash
    { :id => id, :pubmed_id => pubmed_id.to_i, :title => scrub(title), :journal => scrub(journal), :pubdate => pubdate, :abstract => scrub(abstract), :latest_activity => latest_activity ? latest_activity : set_latest_activity, :authors => authors, :citation => scrub(citation), :my_heat => my_heat, :updated_at => updated_at, :created_at => created_at, :percent_summarized => percent_summarized ? percent_summarized : 0, :comments => meta_comments ? meta_comments.count : 0 }
  end

  def scrub(string) #getting wierd intermittent errors from some pubmed into, this should address them.
    string ||= ''
    string.gsub(/['\u2029''\u2028']/,'')
  end

# àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸåÅæÆœŒçÇðÐøØ¿¡ß

  def search_pubmed(search, numresults = 20)
    cleansearch = Rack::Utils.escape(search)
    #cleansearch = search.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').gsub(/[.]/, "+").gsub(/[^0-9A-Za-z'" ]/, '+').gsub(/[ ]/, "%20")


    # Non-alphanumerics are apparently verboden on heroku,,.gsub(/['α']/, "alpha").gsub(/['β']/, "beta").gsub(/['δ']/, "delta").gsub(/['ε']/, "epsilon").gsub(/['ζ']/, "zeta").gsub(/['θ']/, "theta").gsub(/['ι']/, "iota").gsub(/['κ']/, "kappa").gsub(/['λ']/, "lamda").gsub(/['μ']/, "mu").gsub(/['ν']/, "nu").gsub(/['ξ']/, "xi").gsub(/['ο']/, "omicron").gsub(/['π']/, "pi").gsub(/['ρ']/, "rho").gsub(/['Σσς']/, "sigma").gsub(/['Ττ']/, "tau").gsub(/['Υυ']/, "upsilon").gsub(/['Φφ']/, "phi").gsub(/['Χχ']/, "chi").gsub(/['Ψψ']/, "psi").gsub(/['Ωω']/, "omega")

    #Get a list of pubmed IDs for the search terms
    url1 = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=' + cleansearch + '&retmax=' + numresults.to_s
    pids = Nokogiri::XML(open(url1)).xpath("//IdList/Id").map{|p| p.text} * ","
    url2 = pids.empty? ? 'http://www.google.com' : 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' + pids + '&retmode=xml&rettype=abstract'
    data = Nokogiri::XML(open(url2))
    search_results = []
    newpapers = []
    data.xpath('//PubmedArticle').each_with_index do |article, i|
      pid = article.xpath('MedlineCitation/PMID').text
      paper = Paper.find_by_pubmed_id(pid)
      if paper.nil?
        title = article.xpath('MedlineCitation/Article/ArticleTitle').text
        journal = article.xpath('MedlineCitation/Article/Journal/Title').text
        day = article.xpath('MedlineCitation/DateCreated/Day').text.to_i
        month = article.xpath('MedlineCitation/DateCreated/Month').text.to_i
        year = article.xpath('MedlineCitation/DateCreated/Year').text.to_i
        volume = article.xpath('MedlineCitation/Article/Journal/JournalIssue/Volume').text
        issue = article.xpath('MedlineCitation/Article/Journal/JournalIssue/Issue').text
        pagination = article.xpath('MedlineCitation/Article/Pagination/MedlinePgn').text

        if year
          begin
            pubdate = Time.local(year, month, day)
          rescue
            pubdate = Time.local(year)
          end
          # This is the term used to order search results. Add a small pad to reflect pubmed search order, so that search results match what someone would get on an organic pubmed search.
          latest_activity = pubdate + (200 - i).minutes
        else
          latest_activity = Time.now - 1.month
        end
        abstract = article.xpath('MedlineCitation/Article/Abstract/AbstractText').text
        authors = []
        authorlist = article.xpath('MedlineCitation/Article/AuthorList')
        authorlist.xpath('Author').each do |a|
          firstname = a.xpath('ForeName').text
          lastname = a.xpath('LastName').text
          initials = a.xpath('Initials').text
          authors << {:firstname => firstname, :lastname => lastname, :name => lastname + ', ' + firstname }
        end

        if authors.count > 3
          citation_authors = authors[0][:lastname] + ', ' + authors[1][:lastname] + ", et al."
        else
          n = authors.length
          citation_authors = authors.empty? ? '' : (authors.map{|a| a[:name]}.first(n-1)).join(', ') + ', and ' + authors.last[:name] + '.'
        end

        citation = citation_authors + ' "' + title + '" ' + journal + ' ' + volume + (issue ? '.' + issue : '') + ' (' + pubdate.year.to_s + '): ' + pagination + '. Web.'
        paper = {:pubmed_id => pid.to_i, :title => scrub(title), :journal => scrub(journal), :pubdate => pubdate, :abstract => scrub(abstract), :latest_activity => latest_activity, :authors => authors, :citation => scrub(citation), :my_heat => 0}
        newpaper = {:pubmed_id => pid, :title => title, :journal => journal, :pubdate => pubdate, :abstract => abstract, :latest_activity => latest_activity, :authors => authors, :citation => citation}
      else
        paper = paper.to_hash
      end
      newpapers << newpaper
      search_results << paper
    end
    search_results
  end

  def pubmed_search_count(search, date = nil)
    cleansearch = Rack::Utils.escape(search)
    #Get number of pubmed search results for the search terms
    if !date.nil?
      url1 = 'http://eutils.ncbi.nlm.nih.gov/gquery?term=' + cleansearch + '%20AND%20' + (date).strftime('%Y%2f%m%2f%2d') + '%3A3000%5BPublication%20Date%5D&retmode=xml'
    else
      url1 = 'http://eutils.ncbi.nlm.nih.gov/gquery?term=' + cleansearch + '&retmode=xml'
    end
    count = Nokogiri::XML(open(url1)).xpath('//ResultItem/Count').first.text.to_i
  end

  def set_interest
    users = []
    Follow.where('user_id IS NOT NULL').each do |f|
      if (self.title.to_s + ' ' + self.abstract.to_s).downcase.include?(f.search_term.downcase)
        users << f.user
      end
    end
    self.interest = users.uniq.count
    self.save
    self.interest
  end

  def set_all_interest
    follows = Follow.where('user_id IS NOT NULL')
    Paper.all.each do |p|
      users = []
      follows.each do |f|
        if (p.title.to_s + ' ' + p.abstract.to_s).downcase.include?(f.search_term.downcase)
          users << f.user
        end
      end
      p.interest = users.uniq.count
      p.save
    end
  end

  def search_activity(search_term)
    cleansearch = search_term.gsub(/[']/, "''")
    comment_papers = Paper.joins('INNER JOIN "comments" ON "papers"."id" = "comments"."get_paper_id"').where('UPPER("comments"."text") LIKE '"'%" + cleansearch.upcase + "%'")
    summary_papers = Paper.joins('INNER JOIN "assertions" ON "papers"."id" = "assertions"."get_paper_id"').where("UPPER(assertions.text) LIKE '%#{cleansearch.upcase}%' OR UPPER(assertions.method_text) LIKE '%#{cleansearch.upcase}%'")
    (summary_papers + comment_papers).uniq.map{|p| p.to_hash}
  end

# Search for papers with a given search term in the J.Lab database
  def jlab_search(search_term)
    cleansearch = search_term.gsub(/[']/, "''")
    papers = Paper.where("UPPER(title) LIKE '%#{cleansearch.upcase}%' OR UPPER(abstract) LIKE '%#{cleansearch.upcase}%'")
    comment_papers = Paper.joins('INNER JOIN "comments" ON "papers"."id" = "comments"."get_paper_id"').where('UPPER("comments"."text") LIKE '"'%" + cleansearch.upcase + "%'")
    summary_papers = Paper.joins('INNER JOIN "assertions" ON "papers"."id" = "assertions"."get_paper_id"').where("UPPER(assertions.text) LIKE '%#{cleansearch.upcase}%' OR UPPER(assertions.method_text) LIKE '%#{cleansearch.upcase}%'")
    (papers + comment_papers + summary_papers).sort{|x,y| x.latest_activity <=> y.latest_activity}
  end

  def comments_search(search_term)
    papers = jlab_search(search_term)
    if papers.empty?
      []
    else
      comments_search = Paper.joins('INNER JOIN "comments" ON "papers"."id" = "comments"."get_paper_id"').where(' papers.id IN (' + papers.map{|p| p.id} * ',' + ')')
      comments_search.uniq.sort{|x,y| y.latest_activity <=> x.latest_activity}
    end
  end

  # Accepts text input of URl
  # Opens it as HTML
  # Attempts to do so 10 times if it fails for some reason.
  def open_html(url)

    doc = nil
    begin
      doc = Nokogiri::HTML(open(url).read.strip)
    rescue Exception => ex
      attempts = attempts + 1
      retry if(attempts < 10)
    end
    doc
  end


  # Accepts text input of URl
  # Opens it as XML
  # Attempts to do so 10 times if it fails for some reason.
  def open_xml(url)
    doc = nil
    begin
      doc = Nokogiri::XML(open(url).read.strip)
    rescue Exception => ex
      attempts = attempts + 1
      retry if(attempts < 10)
    end
    doc
  end

  def check_blogs
    url = 'http://www.google.com/search?hl=en&q=%22' + self.title.gsub(/[' ']/, "+").gsub(/['.']/, "+").gsub(/[^0-9A-Za-z]/, '+').delete('"').delete("'") + '%22&tbm=blg&tbs=li:1&output=rss'
    blogposts = []
    open_xml.xpath("//item").each do |i|
      posttitle = i.xpath('title').text.gsub(/<\/?[^>]*>/, "")
      url = i.xpath('link').text
      description = i.xpath('description').text.gsub(/<\/?[^>]*>/, "")
      if (posttitle + ' ' + description).include?(self.title.first(20))
        blogposts << {:url => url, :title => posttitle, :description => description}
      end
    end
    blogposts
  end

#Check to see if the paper is filled out. If not, set a delayed job to look it up
  def check_info
    if title.nil?
      delay.lookup_info
    end
  end

  def lookup_info
    if Rails.env.test?
      self.abstract = "The uncanny valley-the unnerving nature of humanlike robots-is an intriguing idea."
      self.journal = "Cognition"
      self.pubdate = (Time.now - 1.month)
      self.title = "Feeling robots and human zombies: Mind perception and the uncanny valley"
      self.citation = "Gray, Kurt, and Wegner, Daniel M. \"Feeling robots and human zombies: Mind perception and the uncanny valley.\" 125.1 (2012): 125-30. Web."
      #Check to see if the ID showed up on pubmed, if not return to the homepage.
      self.authors = [{:firstname=>"Kurt", :lastname=>"Gray", :name=>"Gray, Kurt"}, {:firstname=>"Daniel M", :lastname=>"Wegner", :name=>"Wegner, Daniel M"}]
      self.save
    else
      url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' + self.pubmed_id.to_s + '&retmode=xml&rettype=abstract'
      data = Nokogiri::XML(open(url))

      if data.xpath("/").empty? || data.xpath('//PubmedArticle').nil? || data.xpath('//PubmedArticle').first.nil?
        flash = { :error => "This Pubmed ID is not valid." }
      else
        article = data.xpath('//PubmedArticle').first
        self.title = article.xpath('MedlineCitation/Article/ArticleTitle').text
        self.journal = article.xpath('MedlineCitation/Article/Journal/Title').text
        day = article.xpath('MedlineCitation/DateCreated/Day').text.to_i
        month = article.xpath('MedlineCitation/DateCreated/Month').text.to_i
        year = article.xpath('MedlineCitation/DateCreated/Year').text.to_i
        volume = article.xpath('MedlineCitation/Article/Journal/JournalIssue/Volume').text
        issue = article.xpath('MedlineCitation/Article/Journal/JournalIssue/Issue').text
        pagination = article.xpath('MedlineCitation/Article/Pagination/MedlinePgn').text

        if year != 0
          month = month == 0 ? 1 : month
          day = day == 0 ? 1 : day

          self.pubdate = DateTime.new(year, month, day)
          self.latest_activity = self.pubdate
        else
          self.latest_activity = DateTime.now - 1.month
        end
        self.abstract = article.xpath('MedlineCitation/Article/Abstract/AbstractText').text

        self.authors = []
        authorlist = article.xpath('MedlineCitation/Article/AuthorList')
        authorlist.xpath('Author').each do |a|
          firstname = a.xpath('ForeName').text
          lastname = a.xpath('LastName').text
          initials = a.xpath('Initials').text
          self.authors << {:firstname => firstname, :lastname => lastname, :name => lastname + ', ' + firstname }
        end
        if self.authors.count > 3
          citation_authors = self.authors[0][:lastname] + ', ' + self.authors[1][:lastname] + ", et al."
        else
          n = self.authors.length
          citation_authors = self.authors.empty? ? '' : (self.authors.map{|a| a[:name]}.first(n-1)).join(', ') + ', and ' + self.authors.last[:name] + '.'
        end

        self.citation = citation_authors + ' "' + self.title + '" ' + self.journal + ' ' + volume + (issue ? '.' + issue : '') + ' (' + self.pubdate.year.to_s + '): ' + pagination + '. Web.'
        self.save
        count_figs
      end
    end
  end



#def openxml(source)
#	Nokogiri::XML(open(source))
#end




  def count_figs
    url = 'http://www.ncbi.nlm.nih.gov/pubmed/' + self.pubmed_id.to_s
    doc = open_html(url)
    imagearray = []
    doc.css('img').each do |img|
      if img.attributes.has_key?("src-large")
        imagearray << img.attributes["src-large"].to_s
      end
    end
    self.build_figs(imagearray.count)
    #if doc.css('a.status_icon').text == "Free PMC Article"
    #	pmcid = doc.css('dl.rprtid dd').children[2].text.gsub(/([PMC])/, '')
    #end
    self.delay.grab_figs(imagearray)
  end

  def grab_figs(imagearray)
    #
    #Extract images only for PLoS papers
    #
    #url2 = 'http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.gov:' + pmcid
    #oai = Nokogiri::HTML(open(url2))
    #	unless oai.css('error').attribute("code").value == "idDoesNotExist"
    if self.journal.downcase.include?('plos')
      imagearray.count.times do |n|
        self.figs[n].image_url = "http://www.ncbi.nlm.nih.gov/" + imagearray[n]
        self.figs[n].save
      end
    end
    #	end
  end

#Grab images
  def grab_images
    url = 'http://www.ncbi.nlm.nih.gov/pubmed/' + self.pubmed_id.to_s
    doc = open_html(url)
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

#Checks mendeley for open access status
# Accepts no inputs
  def check_mendeley
    url = 'http://api.mendeley.com/oapi/documents/details/' + pubmed_id.to_s + '?type=pmid&consumer_key=86e4c2e0add7700c7235b2df97bb4b5a050557337'
    uri = URI.parse(url)
    req = Net::HTTP.new(uri.host, uri.port)
    res = req.request_head(uri.path)
    if res.code == "200" || res.code == "301"
      oa = ActiveSupport::JSON.decode(res)
    else
      oa = false
    end
    oa
  end

 # A hash matching months to their respective numbers.
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

#Check to see when the last comment or summary was left on the paper. Used for ranking in search results.

  def set_latest_activity
    activity = (self.meta_comments + self.meta_assertions).map{|p| p.created_at}.compact
    self.pubdate ||= Time.now - 1.month
    self.latest_activity = (activity << self.pubdate).max
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
    self.reaction_map = nil
    set_reaction_map
  end

#Check to see what reactions an object has had and record them to the reaction map

  def check_reactions(object)
    if object.class == Fig
      fig_reactions = []
      fig_reactions << object.reactions
      object.figsections.each{|s| fig_reactions << s.reactions}
      fig_reactions.flatten!
      fig_reactions.map{|r| [r.name, fig_reactions.select{|r2| r2.name == r.name}.count]}.uniq
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
      figs.each do |fig|
        heatmap["fig" + fig.id.to_s] = [fig.heat]
        fig.figsections.each do |s|
          heatmap["figsection" + s.id.to_s] = [s.heat]
        end
      end
      heatmap = calc_heat(heatmap)
      heatmap["paper" + id.to_s] = [heat, [heat, 10].min]
      self.h_map = heatmap
      self.save
    end
    h_map
  end

#Accepts a hash called "heatmap" of the form 'fig[id]' (text) => # of comments and summaries (int)
# ie 'fig4432' => 2
#Calculate the relative heat of each element, with 0 being cool and 100 being warm

  def calc_heat(heatmap)

    #Find the maximum number of comments
    max = heatmap.values.drop(1).map{|h| h[0]}.max
    if max == 0 || max == nil
      max = 1
    end
    #Indicate everything else as a percentage
    heatmap.each do |id, h|
      if id.first(5) == 'paper'
        heatmap[id] = [h, [h[0], 10].min]
      end
      h = h[0]
      h ||= 0
      float = h.to_f/max * 10
      heatmap[id] = [h, float.to_i]
    end
    heatmap
  end

  def add_heat(item)
    if item.class == Paper
      h_map[self.inspect][0] = (self.meta_reactions + self.meta_comments).map{|c| c.user}.uniq.count
      self.save
    else
      self.h_map[item.class.to_s.downcase + item.id.to_s][0] += 1
      self.h_map = calc_heat(self.h_map)
      self.save
    end
  end

  def heat
    (self.meta_reactions + self.meta_comments).map{|c| c.user}.uniq.count
  end

  def my_heat
    h_map ? h_map[self.inspect][0] : 0
  end

  def percent_summarized
    figcount = figs.count
    if figcount > 0
      meta_assertions.select{|a| a.fig_id}.map{|a| a.fig_id}.uniq.count * 100 / figcount
    else
      0
    end
  end

  def heatmap_overview
    hm = heatmap
    max_sections = (figs.map{|f| f.figsections.count}).max.to_i
    overview = [[['Paper', hm['paper' + id.to_s][1], 'paper' + id.to_s]] + [nil] * max_sections]
    figs.sort{|x,y| x.num <=> y.num}.each do |fig|
      figrow = [['Fig ' + fig.num.to_s, hm['fig' + fig.id.to_s][1], 'fig' + fig.id.to_s]]
      #fig.figsections.each do |section|
      #	figrow << [fig.num.to_s + section.letter, heatmap['figsection' + section.id.to_s][1], 'figsection' + section.id.to_s]
      #end
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
    newfigs.to_i
    if newfigs > 0
      newfigs.times do |i|
        self.figs.create(:num => (self.figs.count+1))
      end
      reset_heatmap
    elsif newfigs < 0
      (newfigs * -1).times do
        f = self.figs[-1]
        if f.comments.empty? && f.image.nil? && f.figsections.empty? && f.questions.empty? && f.assertions.empty? && f.reactions.empty?
          f.destroy
        end
        self.reload
      end
      reset_heatmap
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

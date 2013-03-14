class Follow < ActiveRecord::Base

  serialize :latest_search

  belongs_to :user
  has_many :visits, :as => :about, :dependent => :destroy, :order => 'created_at DESC'
  has_many :commentnotices
  belongs_to :follow, :polymorphic => true

  validates :name, :presence => true

#before_save :update_feed
  before_save :set_newcount

  def css_class
    "follow_" + id.to_s
  end

  def inspect
    'follow' + id.to_s
  end

  def feed
    if latest_search
      latest_search.map{|p| p[0]}.select{|p| p[:title]}
    else
      Paper.new.search_pubmed(search_term)
    end
  end


  def update_feed
    if search_term
      pubmed_search = Paper.new.search_pubmed(search_term,40).map{|p| [p, p[:latest_activity]]}
      activity_search = Paper.new.search_activity(search_term).map{|p| [p, p[:latest_activity]]}
      self.latest_search = (pubmed_search + activity_search).sort{|x,y| y[1] <=> x[1]}
    elsif self.follow_type = 'latest_comments'
      self.latest_search = latest_comments
    end
    self.save
    self.user.set_feedhash
    self.latest_search
  end

  #def rehash_feed
  #  latest_search.each do |p|
  #    pmid = p[0][:pubmed_id].to_i
  #    if paper = Paper.find_by_pubmed_id(pmid)
  #      p[0] = paper.to_hash
  #    end
  #  end
  #  self.save
  #
  #end

  def update_all_feeds
    Follow.all.select{|f| !f.user.nil? }.each{|f| f.delay.update_feed}
    User.all.each{|u| u.delay.set_feedhash}
  end


  # Saves the most recent discussions in the system to latest_search
  def latest_comments
    Comment.last(100).reverse.map{|c| c.get_paper}.uniq.map{|p| [p.to_hash, p.latest_activity]}
  end

  def set_newcount
    lastvisit = self.visits.empty? ? Date.new(1900,1,1) : self.visits.first.created_at
    if latest_search && follow_type != 'latest_comments'
      newcount = latest_search.select{|p| p[0][:pubdate] > lastvisit}.count
      if newcount == 40 #Pubmed search results gives an inaccurate number of search results, when the number is low count the results manually in JLab (this is inconvenient for large #s.
        newcount = Paper.new.pubmed_search_count(search_term, lastvisit)
      end
    else
      newcount = 0
    end
    self.newcount = newcount
  end

  def latest_visit
    latest = visits.first(4).map{|v| v.created_at}.select{|v| v < Time.now - 10.seconds}.max
    if latest.nil?
      latest = DateTime.new(1900)
    end
    latest
  end

  def recent_activity
    lastvisit = self.visits.empty? ? Date.new(1900,1,1) : self.visits.first.created_at
    commentnotices.select{|c| c.comment_date > lastvisit}.map{|c| c.paper.pubmed_id}.uniq
  end

  def recent_activity_count
    lastvisit = self.visits.empty? ? Date.new(1900,1,1) : self.visits.first.created_at
    if self.follow_type == 'latest_comments'
      recent = self.latest_search.select{|p| p[1] > lastvisit}.count
    else
      recent = commentnotices.select{|c| c.comment_date > lastvisit}.map{|c| c.paper_id}.uniq.count
    end
    recent
  end

  def comments_feed
    commentnotices.map{|cn| cn.paper.to_hash}.uniq
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
    follow.update_feed
    follow_array.delay.each {|f| f.update_feed; f.save;}
    follow_array
  end


end

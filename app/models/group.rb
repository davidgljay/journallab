class Group < ActiveRecord::Base

  require 'RMagick'
  include Magick

# Used to denote labs, classes, etc. Primarily involved in filtering mechanisms (ie, comments visible to a particular group.
# Elements:
# Name: text - Name of group
# Desc: text - Group description
# Category: string - Type of group (class, lab, etc), affects filtering system used.
# Image_name: Used for the group's image
# Image_uid: Used for the group's image
#
# Connected to User class through memberships model

  serialize :feed
  serialize :most_viewed
  serialize :recent_discussions


  has_many :memberships, :foreign_key => "group_id",
           :dependent => :destroy
  has_many :users, :through => :memberships, :source => :user

#Filter Associations
  has_many :filters, :foreign_key => "group_id",
           :dependent => :destroy
  has_many :discussions, :dependent => :destroy, :order => 'starttime DESC'
  has_many :papers, :through => :discussions, :source => :paper
  has_many :comments, :through => :filters, :source => :comment
  has_many :questions, :through => :filters, :source => :question
  has_many :assertions, :through => :filters, :source => :assertion
  has_many :sumreqs, :dependent => :destroy
  has_many :shares, :dependent => :destroy
  has_many :maillogs, :as => :about
  has_many :visits, :as => :about, :dependent => :destroy, :order => 'created_at DESC'

  image_accessor :image

  validates :code, :uniqueness => true, :allow_nil => true
  validates :urlname, :uniqueness => true, :allow_nil => true
  validates :category, :presence => true
  validates :name, :presence => true
  before_save :check_recent_discussions

#Functions for adding and removing users

  def add(user)
    unless self.users.include?(user)
      self.users << user
      m = self.memberships.find_by_user_id(user.id)
      m.lead = false
      m.save
      user.set_feedhash
      leads.each do |lead|
        Mailer.group_add_notification(self, lead, user).deliver unless self.id == 8
      end
      #user.delay.set_feedhash
    end
  end

#Used in feedhash
  def css_class
    'group' + id.to_s
  end

  def shortname
    if name.length > 25
      name.first(25) + "..."
    else
      name
    end
  end

  def inspect
    "group" + id.to_s
  end

  def to_param  # Make it so that group_path points to /groups/urlname
    self.urlname
  end

  def make_lead(user)
    self.add(user)
    m = self.memberships.find_by_user_id(user.id)
    m.lead = true
    m.save
  end

  def leads
    memberships.all.select{|m| m.lead}.map{|m| m.user}
  end

  def remove(user)
    if self.users.include?(user)
      self.memberships.find_by_user_id(user.id).destroy
      user.set_feedhash
    end
  end

# Public = 1
# Group = 2
# Private = 3
# Functions for setting up filters
  def make_public(item, date = nil, supplementary = false)
    unless make_filter(item, 1, date, supplementary)
      f = find_filter_by_item(item)
      f.state = 1
      f.save
    end
    if item.class != Paper
      item.is_public = true
      item.save
    end
  end

  def make_group(item, date = nil, supplementary = false)
    unless make_filter(item, 2, date, supplementary)
      f = find_filter_by_item(item)
      f.state = 2
      f.save
    end
    unless otherwise_public?(item)
      if item.class != Paper
        item.is_public = false
        item.save
      end
    end
  end

  def make_private(item, date = nil, supplementary = false)
    unless make_filter(item, 3, date, supplementary)
      f = find_filter_by_item(item)
      f.state = 3
      if f.date.nil?
        f.date = date
      end
      f.save
    end
    unless otherwise_public?(item)
      if item.class != Paper
        item.is_public = false
        item.save
      end
    end
  end

# Check to see if an item is public under any other group.
  def otherwise_public?(item)
    item.groups.each do |g|
      if g.filter_state(item) == 1
        return true
      else
        return false
      end
    end
  end

  def make_filter(item, state, date = nil, supplementary = false)
    unless find_filter_by_item(item) || id == nil
      if item.class == Paper
        self.filters.build(:paper_id => item.id, :state => state, :date => date, :supplementary => supplementary).save
      elsif item.class == Comment
        self.filters.build(:comment_id => item.id, :state => state).save
      elsif item.class == Question
        self.filters.build(:question_id => item.id, :state => state).save
      elsif item.class == Assertion
        self.filters.build(:assertion_id => item.id, :state => state).save
      end
    end
    if state == 1 && item.class != Paper
      item.is_public = true
      item.save
    end
  end


# Functions for finding info about filters

  def filter_state(item)
    if !find_filter_by_item(item).nil?
      find_filter_by_item(item).state
    elsif item.is_public?
      1
    else
      3
    end
  end

  def includes_item?(item)
    if find_filter_by_item(item)
      return true
    else
      return false
    end
  end

  def find_filter_by_item(item)
    if item.class == Paper
      self.filters.find_by_paper_id(item.id)
    elsif item.class == Comment
      self.filters.find_by_comment_id(item.id)
    elsif item.class == Question
      self.filters.find_by_question_id(item.id)
    elsif item.class == Assertion
      self.filters.find_by_assertion_id(item.id)
    end
  end

# Filtering Functions

  def filter_count(array, user, mode = 1)
    items = []
    array.select{|c| let_through_filter?(c,user, mode)}.each do |item|
      items << item
      if item.class == Comment
        items << item.comments
      end
    end
    items.flatten.count
  end


  def let_through_filter?(item, user, mode = 1)
# Classes can see everyone's comments, but only their own assertions until the instructor flips a switch.
    if self.category == "class"
      if item.class == Assertion
        if user.lead_of?(self)
          return true
        elsif item.user == user
          return true
        elsif filter_state(item).nil?
          return false
        elsif filter_state(item) >= filter_state(item.get_paper)
          return true
        else
          return false
        end
      else
        (user.member_of?(self) && filter_state(item) <= 2)
      end
    elsif category == "lab"
# Lab members can see one another's comments and questions. All of their assertions are public. They can also see public discussion. 
      if item.class == Assertion
        return item.is_public
      elsif mode == 2
        return (user.member_of?(self) && filter_state(item) == 2)
      elsif mode == 1
        return item.is_public
      end
    elsif category.nil?
      return item.is_public
    end
  end

#
# Functions related to homepage feeds
#

  def update_feed
    items = []
    self.feed = []
    items << shares
    users.each do |u|
      items << u.assertions
      items << u.comments
      items << u.questions
    end
    items.flatten!.uniq.sort!{|x,y| y.created_at <=> x.created_at}.first(20) unless items.empty?
    items.each do |item|
      feed_add(item)
    end
    self.feed
  end

  def prep_feed
    prepped_feed = feed
    if prepped_feed.nil?
      prepped_feed = []
    end
    prepped_feed.each do |f|
      f[:item] = f[:item_type].constantize.find(f[:item_id])
      f[:anon] = f[:item].anonymous
      f[:paper] = Paper.find(f[:paper])
      f[:user] = User.find(f[:user])
    end
    prepped_feed
  end

  def feed_add(item)
    if self.feed.nil?
      self.feed = []
    end
    if item.class == Comment || item.class == Question
      text = "left a #{item.class.to_s.downcase} on #{item.owner.shortname}:"
      bold = false
      sharetext = item.text
      paper = item.get_paper
    elsif item.class == Assertion
      assertions = item.get_paper.meta_assertions
      summaries_of = assertions.select{|a| a.user == item.user}.map{|a| a.owner.shortname} * ', '
      text = "summarized " + summaries_of + "."
      bold = false
      paper = item.get_paper
      feed.delete_if{|i| i[:user] == item.user.id && i[:paper] == paper.id && i[:item_type] == "Assertion"}
    elsif item.class == Share
      text = "shared " + item.owner.shortname
      sharetext = item.text
      bold = false
      paper = item.get_paper
    end
    self.feed << {:user => item.user.id, :text => text, :paper => paper.id, :created_at => item.created_at, :bold => bold, :item_type => item.class.to_s, :item_id => item.id}
    self.feed.sort!{|x,y| y[:created_at] <=> x[:created_at]}
    self.save
  end

  def fix_visits
    Visit.all.each do |v|
      if v.count.nil?
        v.count = 0
        v.save
      end
      if v.count == 0
        v.count = 1
        v.save
      end
    end
  end

#Create a list of the most viewed papers

  def update_most_viewed
    visits = users.map{|u| u.visits}.flatten.select{|v| v.about.class == Paper}
    papers = visits.map{|v| v.about}.uniq
    self.most_viewed = papers.map{|paper| [paper.id, visits.select{|v| v.about.id == paper.id}.count ]}.sort{|x,y| y[1]<=>x[1]}.first(30)
    self.save
    self.most_viewed
  end

  def prep_most_viewed
    prepped_mv = most_viewed
    prepped_mv.each do |f|
      f[0] = Paper.find(f[0])
    end
    prepped_mv
  end

  def most_viewed_add(paper)
    if most_viewed
      if most_viewed.map{|mv| mv[0]}.include?(paper.id)
        spot = most_viewed.index{|mv| mv[0] == paper.id}
        most_viewed[spot][1] += 1
      else
        most_viewed << [paper.id, 1]
      end
      self.most_viewed = most_viewed.sort{|x,y| y[1]<=>x[1]}.first(30)
      self.save
      most_viewed
    end
  end

# List of papers by summary request for the lab 
  def sumreq_feed
    unless sumreqs.empty?
      sumreq_papers = sumreqs.map{|s| s.get_paper_id}.uniq.map{|id| Paper.find(id)}
      sumreq_array = []
      sumreq_papers.each do |p|
        p_sumreqs = sumreqs.select{|s| s.get_paper == p && !s.summarized}
        sumreq_array << [p, p_sumreqs.count, p_sumreqs.map{|s| [s.owner.shortname, p_sumreqs.select{|p_s| p_s.owner_id == s.owner_id}.count]}.uniq]
      end
      sumreq_array.sort!{|x,y| y[1] <=> x[1]}.delete_if{|x| x[1] == 0}
      sumreq_array
    end
  end

  def sumreq_count
    sumreqs.select{|s| !s.summarized}.count
  end


# Does this group have any new shares? (In which case we should send out an e-mail)
  def newshares?
    !shares.select{|share| share.created_at > Time.now - 1.day}.empty?
  end

# Functions related to Journal clubs
  def current_discussion
    discussions.select{|d| d.starttime}.first
  end

  def discuss(paper, user)
    if user.lead_of?(self)
      self.papers << paper
      d = self.discussions.select{|d| d.paper == paper}.first
      d.starttime = Time.now
      d.user = user
      d.save
      self.memberships.each {|m| m.delay.save; m.user.delay.set_feedhash}
      self.reload
      self.set_recent_discussions
    end
  end

  def undiscuss(paper)
    d = self.discussions.select{|d| d.paper == paper}
    if d
      d.each{|disc| disc.destroy}
      self.memberships.each {|m| m.delay.save; m.user.delay.set_feedhash}
    end
  end

  def set_newcount
    memberships.each{|m| m.save}
  end

  def newcount(user)
    memberships.select{|m| m.user == user}.first.newcount
  end

  # Check to verify that the "recent_discussions" array has been saved to the model
  # If not, set it
  def check_recent_discussions
    set_recent_discussions if recent_discussions.nil?
  end

  #Saves an array which powers the "recent discussions" slideshow in Groups:Show

  def set_recent_discussions
    recent_discussions = []

    self.discussions[1..-1].to_a.each do |d|
      discussion_id = d.id
      paper = d.paper
      paper_id = d.paper_id
      title = paper.title
      reactions = []
      paper.meta_reactions.each do |r|
        reactions << {:name => r.name, :number => paper.meta_reactions.select{|r2| r2.name == r.name}.count}
      end
      reactions.uniq!
      if !paper.figs.empty?
        hottest_fig = paper.figs.map{|f| [f,f.heat]}.sort{|x,y| y[1]<=>x[1]}.first[0]
        if !hottest_fig.hottest_comment.nil?
          hottest_fig_comment = hottest_fig.hottest_comment.text.length > 500 ? hottest_fig.hottest_comment.text.first(500) + '...' : hottest_fig.hottest_comment.text
        else
          hottest_fig_comment = nil
        end
      else
        hottest_fig = nil
        hottest_fig_comment = nil
      end
      recent_discussions << {:dission_id => discussion_id, :paper_id => paper_id, :title => title, :reactions => reactions, :hottest_fig => hottest_fig, :hottest_fig_comment => hottest_fig_comment}
    end
    self.recent_discussions = recent_discussions
    self.save
  end

  def nofityGroup
  end

  def remindGroup
  end

  def emailAuthor
  end

end

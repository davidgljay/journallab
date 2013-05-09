# == Schema Information
# Schema version: 20110330182458
#
# Table name: users
#
#  id         :integer         not null, primary key
#  firstname  :string(255)
#  lastname   :string(255)
#  email      :string(255)
#  password   :string(255)
#  admin      :boolean
#  anon_name  :string(255)
#  specialization  :string(255)
#  impact     :string(255) as hash
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'
require 'csv'


class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable,  and :activatable

  devise :database_authenticatable, :registerable, :confirmable, :encryptable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :firstname, :lastname, :email, :password, :password_confirmation, :specialization, :profile_link, :position, :institution, :homepage, :cv, :image, :remember_me

  serialize :impact
  serialize :feedhash
  serialize :orientationhash
  serialize :recent_discussions

  has_many :assertions, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :shares, :dependent => :destroy
  has_many :reactions, :dependent => :destroy
  has_many :discussions
  has_many :visits, :foreign_key => "user_id"
  has_many :memberships, :foreign_key => "user_id", :dependent => :destroy
  has_many :groups, :through => :memberships, :source => :group
  has_many :sumreqs
  has_many :maillogs
  has_many :subscriptions
  has_many :votes_for_me, :class_name => "Vote", :foreign_key => "vote_for_id"
  has_many :follows, :order => 'created_at ASC', :dependent => :destroy
  has_many :anons, :dependent => :destroy
  has_many :share_visits, :class_name => "Visit", :as => :about, :order => 'created_at DESC'
  has_many :folders, :dependent => :destroy
  has_many :notes, :dependent => :destroy

  before_save :set_impact
  before_save :set_certified
  before_save :check_feedhash
  before_save :default_image
  after_save :create_to_read
  after_save :set_subscriptions

  image_accessor :image


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

#Validationville

  validates :firstname,  :presence => true,
            :length => { :within => 1..50 }
  validates :lastname,  :presence => true,
            :length => { :within => 1..50 }
  validates :email, :presence => true,
            :format   => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }


#Some functions for calling names
  def name
    name = firstname.to_s + ' ' + lastname.to_s
  end

  def default_image
    if self.image.nil?
      self.image_url = 'http://s3.amazonaws.com/j.lab-images/static/default-user.png'
    end
  end

#Commenting out authentication functionality now that I'm switching to Devise.

#Set up a test to see if the user's password matches
#   def has_password?(submitted_password)
#      encrypted_password == encrypt(submitted_password)
#   end


  def inspect
    name
  end

#Set up an authentication method
#   def self.authenticate(email, submitted_password)
#       user = find_by_email(email.downcase)
#       return nil if user.nil?
#       return user if user.has_password?(submitted_password)
#   end



#And an authentication for use with cookies, for beefier security
#   def self.authenticate_with_salt(id, cookie_salt)
#       user= find_by_id(id)
#       (user && user.salt == cookie_salt) ? user : nil #OK, so cookie_salt is the user id plus the user's salt, NOT encoded I guess?!
#   end

#Check to see if a user has visited a particular paper

  def visited?(paper)
    visited_papers.include?(paper)
  end

  def visited_papers
    visits.select{|v| v.about_type == 'Paper'}.map{|v| v.about}
  end


#Create a vote command and a command to check for a vote. This is way klunkier than it needs to be, but it works.
# A some point this should be updated to support polymorphic associations...

  def vote!(candidate)
    if candidate.class == Comment
      v = votes.create!(:comment => candidate)
    elsif candidate.class == Question
      v = votes.create!(:question => candidate)
    elsif candidate.class == Assertion
      v = votes.create!(:assertion => candidate)
    end
  end

  def voted_for?(candidate)
    if candidate.class == Comment
      votes.find_by_comment_id(candidate.id)
    elsif candidate.class == Question
      votes.find_by_question_id(candidate.id)
    elsif candidate.class == Assertion
      votes.find_by_assertion_id(candidate.id)
    end
  end

#Calculates the number of people who have viewed your work on Journal Lab (not counting random views from the interwebs)

  def set_impact
    comment_papers = comments.map{|c| c.get_paper}
    reaction_papers = reactions.map{|r| r.get_paper}
    assertion_papers = assertions.map{|a| a.get_paper}
    visits = (comment_papers + reaction_papers + assertion_papers).flatten.uniq.map{|p| p.visits}.flatten
    self.impact = {:visits => visits.count, :users => visits.map{|v| v.user_id}.uniq.count}
  end

# Functionality related to groups

  def member_of?(group)
    self.groups.include?(group)
  end

  def lead_of?(group)
    if groups.include?(group)
      group.memberships.find_by_user_id(self.id).lead
    else
      return false
    end
  end

  def get_group
    if !groups.empty?
      groups[-1]
    else
      #Right now users without groups behave strangly in the system. Later I should replace this with an overarching "public" group that has special behavior, but that can come after our lab tests...
      Group.new
    end
  end

  def colors

    colors = ["Aqua","Aquamarine","Azure","Beige","Bisque","Black","Blue","Brown","Chartreuse","Chocolate","Coral","Cornflower Blue","Cornsilk","Crimson","Cyan","Forest Green","Fuchsia", "Ghost White","Gold","Goldenrod","Gray","Green","Grey","Hot Pink","Indigo ","Ivory","Khaki","Lavender","Lemon Chiffon","Light Blue","Lime Green","Linen","Magenta","Maroon","Olive","Orange","Orchid","Pink","Plum","Powder Blue","Purple","Red","Royal Blue","Salmon","Sandy Brown","Sea Green","Sienna","Silver","Sky Blue","Snow","Steel Blue","Tan","Teal","Thistle","Tomato","Turquoise","Violet","Wheat","White","White Smoke","Yellow"]

  end


  def anon_name(paper)
    self.anons.select{|a| a.paper == paper}.first.name
  end


  def anon?(user)
    # Users can see themselves
    if self == user
      return false
    end
    self.groups.each do |g|

      # Users can see their real names if they are part of the same lab
      if g.users.include?(user) && g.category == "lab"
        return false
        # Instructors can see the names of their students
      elsif g.users.include?(user) && user.lead_of?(g) && g.category == "class"
        return false
      end
    end
    return true
  end

  #
  # Mail Subscription Management
  # 

  #Unsubscribe from everything
  def unsubscribe
    subscriptions.each{|s| s.receive_mail = false; s.save}
  end

  #Undo a universal unsubscribe, this is probably not necessary
  def receive_mail?(category = "all")
    subscriptions.select{|s| (s.category == "all" || s.category == category) && !s.receive_mail}.empty?
  end

  #Set a user's default subscriptions
  def set_subscriptions
    if subscriptions.empty?
      Subscription.new.defaults.each do |s|
        self.subscriptions.create(:category => s, :receive_mail => true)
      end
    elsif subscriptions.count == 1 && subscriptions.first.category == 'all'
      setting = subscriptions.first.receive_mail
      Subscription.new.defaults.each do |s|
        self.subscriptions.create(:category => s, :receive_mail => setting)
      end
    end
  end

  # Return a map of a user's subscriptions
  def subscription_map
    hash = {}
    subscriptions.each do |s|
      hash[s.category] = s.receive_mail
    end
    hash
  end

  #
  # Generates a feed of the form [papers[],comments{}], where papers[] is a list of the 10 most recently viewed papers from most recent to least recent, and comments{} is a hash of the form {:paper_id => [comments on that paper]} 
  #
  def recent_activity
    actions = (self.comments.to_a + self.questions.to_a + self.shares.to_a)
    activity = Hash.new
    actions.each do |a|
      p = a.get_paper
      activity[p] = []
      activity[p] << a
    end
    activity
  end


  def deliver_user_verification_instructions!
    reset_perishable_token!
    Mailer.deliver_user_verification_instructions(self)
  end

#
# Functions related to the homepage feeds
#

  def follow!(item)
    self.follows.create(:follow => item) unless self.follows.map{|f| f.follow}.include?(item)
  end


  def assign_anon_name(paper)
    if self.anons.select{|a| a.paper == paper}.empty?
      a = self.anons.new(:paper => paper)
      a.generate
    end
  end

#
# Functions relates to share feed
#
  def new_shares
    lastvisit = share_visits.empty? ? Date.new(1900,1,1) : share_visits.first.created_at
    groups.map{|g| g.shares}.flatten.select{|s| s.created_at > lastvisit}.count
  end

  def shares_feed
    feed = []
    lastvisit = share_visits.count < 2 ? Date.new(1900,1,1) : share_visits[1].created_at
    shares = groups.map{|g| g.shares}.flatten.sort{|x,y| y.created_at <=> x.created_at}
    shares.first(20).each do |s|
      feed << [s, s.created_at > lastvisit]
    end
    feed
  end

# Search user history

  def history_search(search_term)
    visited_papers.select{|p| p.title.include?(search_term) || p.abstract.include?(search_term) || p.meta_assertions.map{|a| a.text.to_s + ' ' + a.method_text.to_s }.include?(search_term) || p.meta_comments.map{|c| c.text}.to_s.include?(search_term)}
  end

  def create_to_read
    self.folders.create(:name => "To Read") if self.folders.empty?
  end

#Check whether the user is certified to post

  def set_certified
    allowed_domains = ['nih.gov', 'ucsfmedctr.org', '.cirm.ca.gov']
    self.certified ||= self.email.last(4) == '.edu' || allowed_domains.include?(self.email.split('@').last)
    return true
  end

  #Move data about the user's feeds into a handy dandy hash for quick retrieval on homepage load.
  #Activated by Follow.update_all_feeds during daily feed update.

  def set_feedhash
    feeds = []
    self.follows.each do |f|
      feeds << {:id => f.id, :name => f.name, :newcount => f.newcount, :recent_activity => f.recent_activity.count, :type => 'follow', :css_class => f.css_class}
    end
    self.groups.select{|g| g.category == 'jclub' && g.current_discussion}.each do |g|
      feeds << {:id => g.id, :name => g.name, :urlname => g.urlname, :recent_activity => g.newcount(self), :newcount => 0, :type => 'group', :css_class => g.css_class }
    end
    self.feedhash = feeds
    self.save
  end

  def check_feedhash
    if self.feedhash.nil?
      set_feedhash
    end
  end

=begin

  User Orientation Process

  Step 1: Create 5 Feeds
  Substeps: 1-5 Feeds
  Step 2:  Join a Journal Club
  Substeps: None
  Step 3: Complete your profile
  Substeps: Complete profile elements
  Step 4: Leave a Comment
  Substeps: None (Slideshow to show process?)
  Step 5: Create a Summary
  Substeps: None

=end

  def check_orientation
    hash = {}
    if self.orientationhash.nil?
      oldcomplete = 0
      currentstep = 0
    else
      oldcomplete = self.orientationhash[:complete]
      currentstep = self.orientationhash[:step]
    end
    #Step 1:  Create 5 Feeds
    if self.follows.count < 5 && currentstep == 0
      hash[:complete] = self.follows.count * 5 + 5
      hash[:step] = 0
    #Step 2: Join a Journal Club
    elsif self.groups.empty? && currentstep <= 1
      hash[:complete] = 30
      hash[:step] = 1
    #Step 3: Complete your profile
    elsif (self.institution.nil? || self.position.nil?) && currentstep <= 2
      hash[:complete] = 35
      hash[:step] = 2
    #Step 4: Leave a comment
    elsif self.reactions.empty? && currentstep <= 3 && self.certified
      hash[:complete] = 55
      hash[:step] = 3
    #Step 5: Create a Summary
    elsif self.assertions.empty? && currentstep <= 4 && self.certified
      hash[:complete] = 75
      hash[:step] = 4
    #Complete!
    else
      hash[:complete] = 100
      hash[:step] = 5
    end
    self.orientationhash = hash
    self.save
    oldcomplete != hash[:complete]
  end

  def self.orientation_msg
    {
      5 => "Thanks for registering, to get started....",
      10 => "You got it! Just 4 more.",
      15 => "Great, 3 to go.",
      20 => "You're on fire!",
      25 => "One more to go! Almost there..",
      30 => "Great work! Keep creating as many feeds as you like.",
      35 => "Nice job. Now let's get you ready to post.",
      55 => "Fantastic, now you're ready to share your insights!",
      75 => "Commenting is fast! Leave thoughts on a paper as you have them.",
      100 => "100%, you're all done! Congratulations!"
    }
  end

  #Collects recent discussions that the user might find interesting for their homepage.

  def set_recent_discussions

    #Collect papers from my feeds.
    followPapers = self.follows.map{|f| f.commentnotices.map{|c| c.paper}}.flatten
    groupPapers = self.groups.map{|g| g.papers}.flatten
    visitedPapers = self.visits.select{|v| v.about_type == 'Paper'}.map{|v| v.about}
    relevantDiscussions = [followPapers + visitedPapers + groupPapers].select{|p| p.meta_reactions > 2}.uniq.flatten.sort{|x,y| y.latest_activity<=>x.latest_activity }
    recent_discussions = Paper.prepSlideshow(relevantDiscussions)
    if recent_discussions.count < 10 && (a = Analysis.find_by_description('recent_discussions'))
      recent_discussions += a.cache.to_a
    end
    self.recent_discussions = recent_discussions.uniq.first(10)
    self.save
    GC.start
  end

  def self.set_all_recent_discussions
     User.all.each{|u| u.delay.set_recent_discussions}
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["Name", "Email", "Registered On", "Latest Visit", "Days Btw Reg and Latest Visit", "Days Logged In This Month", "Paper Views", "Feed Views", "Number of Feeds", "Comments", "Comments this month", "Reactions", "Reactions this month", "Summaries", "Summaries this month", "Nods Given", "Nods Received"]
      User.all.each do |user|
        name = user.name
        email = user.email
        registered_on = user.created_at.strftime('%D')
        last_active = user.visits.last ? user.visits.last.created_at : nil
        time_since_last = (([user.visits.map{|v| v.created_at}, user.created_at].flatten.max - user.created_at)/86400).to_i
        logins_this_month = user.visits.select{|v| v.created_at > Time.now - 1.month}.map{|v| v.created_at.to_date}.uniq.count
        paper_views = user.visits.select{|v| v.about_type == 'Paper'}.count
        feed_views = user.visits.select{|v| v.about_type == 'Feed'}.count
        num_feeds = user.follows.count
        comments = user.comments.count
        comments_this_month = user.comments.select{|i| i.created_at > Time.now - 1.month}.count
        reactions = user.reactions.count
        reactions_this_month = user.reactions.select{|i| i.created_at > Time.now - 1.month}.count
        summaries = user.assertions.count
        summaries_this_month = user.assertions.select{|i| i.created_at > Time.now - 1.month}.count
        nods_given = user.votes.count
        nods_for_user = user.votes_for_me.count
        csv << [name, email, registered_on, last_active, time_since_last, logins_this_month, paper_views, feed_views, num_feeds, comments, comments_this_month, reactions, reactions_this_month, summaries, summaries_this_month, nods_given, nods_for_user ]
      end
    end
  end

end

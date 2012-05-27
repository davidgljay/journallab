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
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'


class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable,  and :activatable

  devise :database_authenticatable, :registerable, :confirmable, :encryptable,
         :recoverable, :rememberable, :trackable, :validatable
	attr_accessible :firstname, :lastname, :email, :password, :password_confirmation, :specialization, :profile_link, :position, :institution, :homepage, :cv, :image, :remember_me

        before_validation :assign_anon_name


        has_many :assertions
        has_many :comments
        has_many :questions
        has_many :votes
        has_many :shares
        has_many :visits, :foreign_key => "user_id",
                          :dependent => :destroy
        has_many :visited_papers, :through => :visits, :source => :paper
        has_many :memberships, :foreign_key => "user_id",
                           :dependent => :destroy
        has_many :groups, :through => :memberships, :source => :group
	has_many :sumreqs, :dependent => :destroy
        has_many :maillogs
        has_many :subscriptions
        has_many :votes_for_me, :class_name => "Vote", :foreign_key => "vote_for_id"
	has_many :follows

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
      #  validates :password, :presence => true,
      #          :confirmation => true,
      #          :length => {:within => 6..40},
      #          :on => :create
      #  validates :password, :confirmation => true,
      #          :length => {:within => 6..40},
      #          :allow_blank => true,
      #          :on => :update
	# validates :anon_name,  :uniqueness => true


#Some functions for calling names
  def name
      name = firstname.to_s + ' ' + lastname.to_s
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

# Functionality related to groups

  def member_of?(group)
     groups.include?(group)
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
      groups.last
     else
   #Right now users without groups behave strangly in the system. Later I should replace this with an overarching "public" group that has special behavior, but that can come after our lab tests...
      Group.new
     end
  end

  def colors

    colors = ["Aqua","Aquamarine","Azure","Beige","Bisque","Black","Blue","Brown","Chartreuse","Chocolate","Coral","Cornflower Blue","Cornsilk","Crimson","Cyan","Forest Green","Fuchsia", "Ghost White","Gold","Goldenrod","Gray","Green","Grey","Hot Pink","Indigo ","Ivory","Khaki","Lavender","Lemon Chiffon","Light Blue","Lime Green","Linen","Magenta","Maroon","Olive","Orange","Orchid","Pink","Plum","Powder Blue","Purple","Red","Royal Blue","Salmon","Sandy Brown","Sea Green","Sienna","Silver","Sky Blue","Snow","Steel Blue","Tan","Teal","Thistle","Tomato","Turquoise","Violet","Wheat","White","White Smoke","Yellow"]

  end

# Functionality related to semin-anonymous names for users
  def generate_anon_name

    animals = ["Aardvark","Alligator","Buffalo","Ant","Anteater","Antelope","Ape","Armadillo","Donkey","Baboon","Badger","Barracuda","Bat","Bear","Beaver","Bee","Bison","Boar","Buffalo","Butterfly","Camel","Caribou","Cat","Caterpillar","Cow","Chamois","Cheetah","Chicken","Chimpanzee","Cobra","Cormorant","Coyote","Crab","Crane","Crocodile","Crow","Deer","Dog","Dogfish","Dolphin","Donkey","Dove","Dragonfly","Duck","Dugong","Eagle","Echidna","Eel","Eland","Elephant","Elephant seal","Elk","Falcon","Ferret","Finch","Fly","Fox","Frog","Gaur","Gazelle","Gerbil","Giraffe","Gnu","Goat","Goose","Gorilla","Guanaco","Guinea fowl","Guinea pig","Gull","Hamster","Hare","Hawk","Hedgehog","Heron","Hippopotamus","Hornet","Horse","Human","Hyena","Iguana","Jackal","Jaguar","Jellyfish","Kangaroo","Koala","Komodo dragon","Kouprey","Kudu","Lark","Lemur","Leopard","Lion","Llama","Lobster","Lyrebird","Magpie","Mallard","Manatee","Meerkat","Mink","Mole","Monkey","Moose","Mosquito","Mouse","Mule","Narwhal","Nightingale","Okapi","Oryx","Ostrich","Otter","Owl","Ox","Oyster","Panda","Panther","Partridge","Peafowl","Pelican","Penguin","Pigeon","Platypus","Pony","Porcupine","Quelea","Rabbit","Raccoon","Ram","Raven","Reindeer","Rhinoceros","Salamander","Sea lion","Seahorse","Seal","Seastar","Shark","Sheep","Shrew","Snail","Snake","Spider","Squid","Squirrel","Swan","Tapir","Tiger","Toad","Turkey","Turtle","Walrus","Water Buffalo","Whale","Wolf","Wombat","Yak","Zebra"]
   
    self.anon_name = self.colors[rand(self.colors.length - 1)] + ' ' + animals[rand(animals.length - 1)]
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

  def unsubscribe
    subscriptions.create!(:category => "all", :receive_mail => false)
  end

  def receive_mail?
    subscriptions.select{|s| s.category == "all" && !s.receive_mail}.empty?
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


    def assign_anon_name
      if self.anon_name.nil?
         self.anon_name = self.generate_anon_name
      end
    end

  private

#    def encrypt_password
#      if password
#        self.password_salt = make_salt if new_record?
#        self.encrypted_password = encrypt(password)
#      end
#    end


#    def encrypt(string)
#      secure_hash(string)
#    end

#    def make_salt
#      secure_hash("#{Time.now.utc}--#{password}")
#    end

#    def secure_hash(string)
#      Digest::SHA2.hexdigest(string)
#    end

end

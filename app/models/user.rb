# == Schema Information
# Schema version: 20110330182458
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'

class User < ActiveRecord::Base
	attr_accessor :password	
	attr_accessible :firstname, :lastname, :email, :password, :password_confirmation, :specialization, :profile_link

        has_many :microposts, :dependent => :destroy
        has_many :relationships, :foreign_key => "follower_id",
                               :dependent => :destroy
        has_many :following, :through => :relationships, :source => :followed

        has_many :reverse_relationships, :foreign_key => "followed_id",
                               :class_name => "Relationship",
                               :dependent => :destroy
        has_many :followers, :through => :reverse_relationships, :source => :follower

        has_many :assertions
        has_many :comments
        has_many :questions
        has_many :votes
        has_many :visits, :foreign_key => "user_id",
                          :dependent => :destroy
        has_many :visited_papers, :through => :visits, :source => :paper
        has_many :memberships, :foreign_key => "user_id",
                           :dependent => :destroy
        has_many :groups, :through => :memberships, :source => :group


	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

#Validationville

	validates :firstname,  :presence => true,
		:length => { :within => 1..50 }
	validates :lastname,  :presence => true,
		:length => { :within => 1..50 }
	validates :email, :presence => true,
		:format   => { :with => email_regex },
		:uniqueness => { :case_sensitive => false }
	validates :password, :presence => true,
		:confirmation => true,
		:length => { :within => 6..30 }  
	validates :anon_name,  :uniqueness => true

  before_save :encrypt_password, :assign_anon_name

#Some functions for calling names
  def name
      name = firstname.to_s + ' ' + lastname.to_s
  end   

#Set up a test to see if the user's password matches
   def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
   end


#Set up an authentication method
   def self.authenticate(email, submitted_password)
       user = find_by_email(email.downcase)
       return nil if user.nil?
       return user if user.has_password?(submitted_password)
   end

#Reset password

   def reset_user_password(user)
     if admin?
       words = ["Life", "From", "Wikipedia,", "the", "free", "encyclopedia", "For", "other", "uses,", "see", "Life", "(disambiguation).", "Life", "(Biota", "/", "Vitae", "/", "Eobionti)", "Plants", "in", "the", "Rwenzori", "Mountains,", "Uganda", "Scientific", "classification", "Domains", "and", "kingdoms", "Life", "on", "Earth:", "Noncellular", "life", "(viruses)", "[note", "1]", "Cellular", "life", "Bacteria", "Archaea", "Eukarya", "Protista", "Fungi", "Plantae", "Animalia", "Life", "(cf.", "biota)", "is", "a", "characteristic", "that", "distinguishes", "objects", "that", "have", "signaling", "and", "selfsustaining", "processes", "(i.e.,", "living", "organisms)", "from", "those", "that", "do", "either", "because", "such", "functions", "have", "ceased", "(death),", "or", "else", "because", "they", "lack", "such", "functions", "and", "are", "classified", "as", "inanimate.[3][4]", "Biology", "is", "the", "science", "concerned", "with", "the", "study", "of", "life.", "Living", "organisms", "undergo", "metabolism,", "maintain", "homeostasis,", "possess", "a", "capacity", "to", "grow,", "respond", "to", "stimuli,", "reproduce", "and,", "through", "natural", "selection,", "adapt", "to", "their", "environment", "in", "successive", "generations.", "More", "complex", "living", "organisms", "can", "communicate", "through", "various", "means.[1][5]", "A", "diverse", "array", "of", "living", "organisms", "(life", "forms)", "can", "be", "found", "in", "the", "biosphere", "on", "Earth,", "and", "the", "properties", "common", "to", "these", "plants,", "animals,", "fungi,", "protists,", "archaea,", "and", "bacteria—are", "a", "carbon", "and", "waterbased", "cellular", "form", "with", "complex", "organization", "and", "heritable", "genetic", "information.", "In", "philosophy", "and", "religion,", "the", "conception", "of", "life", "and", "its", "nature", "varies.", "Both", "offer", "interpretations", "as", "to", "how", "life", "relates", "to", "existence", "and", "consciousness,", "and", "both", "touch", "on", "many", "related", "issues,", "including", "life", "stance,", "purpose,", "conception", "of", "a", "god", "or", "gods,", "a", "soul", "or", "an", "afterlife.", "Contents", "[hide]", "1", "Early", "theories", "about", "life", "1.1", "Materialism", "1.2", "Hylomorphism", "1.3", "Vitalism", "2", "Definitions", "2.1", "Biology", "2.2", "Biophysics", "2.3", "Living", "systems", "theories", "3", "Origin", "4", "Conditions", "for", "life", "4.1", "Range", "of", "tolerance", "4.2", "Extremophiles", "4.3", "Chemical", "element", "requirements", "5", "Classification", "of", "life", "6", "Extraterrestrial", "life", "7", "Death", "7.1", "Extinction", "7.2", "Fossils", "8", "See", "also", "9", "Notes", "10", "References", "11", "Further", "reading", "12", "External", "links", "Early", "theories", "about", "life", "Materialism", "Plant", "life", "Herds", "of", "zebra", "and", "impala", "gathering", "on", "the", "Maasai", "Mara", "plain", "An", "aerial", "photo", "of", "microbial", "mats", "around", "the", "Grand", "Prismatic", "Spring", "of", "Yellowstone", "National", "Park", "Some", "of", "the", "earliest", "theories", "of", "life", "were", "materialist,", "holding", "that", "all", "that", "exists", "is", "matter,", "and", "that", "all", "life", "is", "merely", "a", "complex", "form", "or", "arrangement", "of", "matter.", "Empedocles", "(430", "BC)", "argued", "that", "every", "thing", "in", "the", "universe", "is", "made", "up", "of", "a", "combination", "of", "four", "eternal", "elements", "or", "roots", "of", "all:", "earth,", "water,", "air,", "and", "fire.", "All", "change", "is", "explained", "by", "the", "arrangement", "and", "rearrangement", "of", "these", "four", "elements.", "The", "various", "forms", "of", "life", "are", "caused", "by", "an", "appropriate", "mixture", "of", "elements.", "For", "example,", "growth", "in", "plants", "is", "explained", "by", "the", "natural", "downward", "movement", "of", "earth", "and", "the", "natural", "upward", "movement", "of", "fire.[6]", "Democritus", "(460", "BC),", "the", "disciple", "of", "Leucippus,", "thought", "that", "the", "essential", "characteristic", "of", "life", "is", "having", "a", "soul", "(psyche).", "In", "common", "with", "other", "ancient", "writers,", "he", "used", "the", "term", "to", "mean", "the", "principle", "of", "living", "things", "that", "causes", "them", "to", "function", "as", "a", "living", "thing.", "He", "thought", "the", "soul", "was", "composed", "of", "fire", "atoms,", "because", "of", "the", "apparent", "connection", "between", "life", "and", "heat,", "and", "because", "fire", "moves.[7]", "He", "also", "suggested", "that", "humans", "originally", "lived", "like", "animals,", "gradually", "developing", "communities", "to", "help", "one", "another,", "originating", "language,", "and", "developing", "crafts", "and", "agriculture.[8]", "In", "the", "scientific", "revolution", "of", "the", "17th", "century,", "mechanistic", "ideas", "were", "revived", "by", "philosophers", "like", "Descartes.", "Hylomorphism", "Hylomorphism", "is", "the", "theory", "(originating", "with", "Aristotle", "that", "all", "things", "are", "a", "combination", "of", "matter", "and", "form.", "Aristotle", "was", "one", "of", "the", "first", "ancient", "writers", "to", "approach", "the", "subject", "of", "life", "in", "a", "scientific", "way.", "Biology", "was", "one", "of", "his", "main", "interests,", "and", "there", "is", "extensive", "biological", "material", "in", "his", "extant", "writings.", "According", "to", "him,", "all", "things", "in", "the", "material", "universe", "have", "both", "matter", "and", "form.", "The", "form", "of", "a", "living", "thing", "is", "its", "soul", "(Greek", "psyche,", "Latin", "anima).", "There", "are", "three", "kinds", "of", "souls:", "the", "vegetative", "soul", "of", "plants,", "which", "causes", "them", "to", "grow", "and", "decay", "and", "nourish", "themselves,", "but", "does", "not", "cause", "motion", "and", "sensation;", "the", "animal", "soul", "which", "causes", "animals", "to", "mov", "Vitalism", "Vitalism", "is", "the", "belief", "Later,", "Helmholtz,", "anticipated", "by", "Mayer,", "Definitions", "It", "is", "still", "a", "Biology", "Since", "there", "Homeostasis:", "R", "Organization:", "Being", "structurally", "composed", "of", "one", "or", "more", "ce", "Metabol", "Growth:", "Adaptati", "Respo", "Reprodu", "Proposed", "To", "reflect", "the", "minimum", "phenomena", "required,", "some", "have", "proposed", "other", "biological", "definitions", "of", "life:", "A", "network", "of", "inferior", "negative", "feedbacks", "(regulatory", "mechanisms)", "subordinated", "to", "a", "superior", "positive", "feedback", "(potential", "of", "expansion,", "reproduction).[18]", "A", "systemic", "definition", "of", "life", "is", "that", "living", "things", "are", "selforganizing", "and", "autopoietic", "(selfproducin", "Living", "beings", "are", "thermodynamic", "systems", "that", "have", "an", "organized", "molecular", "structure.[20]", "Things", "with", "the", "capacity"]
    user.password = ''
    4.times do
      user.password << words[rand(words.length)]
    end
    user.save
    user.password
   else
    return false
   end
end

#And an authentication for use with cookies, for beefier security
   def self.authenticate_with_salt(id, cookie_salt)
       user= find_by_id(id)
       (user && user.salt == cookie_salt) ? user : nil #OK, so cookie_salt is the user id plus the user's salt, NOT encoded I guess?!
   end

#Create a feed of the user's microposts
  def feed
    Micropost.from_users_followed_by(self)
  end

#Create following and unfollowing. This is an attribute of the user, not of the relationship, since the rel is created and destroyed.

   def following?(followed)
      relationships.find_by_followed_id(followed)
   end

   def follow!(followed)
      relationships.create!(:followed_id => followed.id)
   end

   def unfollow!(followed)
      relationships.find_by_followed_id(followed).destroy
   end

#Check to see if a user has visited a particular paper
  
   def visited?(paper)
       visited_papers.include?(paper)
   end


#Create a vote command and a command to check for a vote. This is way klunkier than it needs to be, but it works.

  def vote!(candidate)
      if candidate.class == Comment
        votes.create!(:comment => candidate)
      elsif candidate.class == Question
        votes.create!(:question => candidate)
      elsif candidate.class == Assertion
        votes.create!(:assertion => candidate)
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




  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def assign_anon_name
      if self.anon_name.nil?
         self.anon_name = self.generate_anon_name
      end
    end

    def encrypt(string)
      secure_hash(string)
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end

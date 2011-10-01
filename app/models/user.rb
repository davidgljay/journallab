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
	attr_accessible :name, :email, :password, :password_confirmation

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
        has_many :votes
        has_many :visits
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

  before_save :encrypt_password

#Some funcations for calling names
  def name
      name = firstname.to_s + ' ' + lastname.to_s
  end   

#Set up a test to see if the user's password matches
   def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
   end

#Set up an authentication method
   def self.authenticate(email, submitted_password)
       user = find_by_email(email)
       return nil if user.nil?
       return user if user.has_password?(submitted_password)
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

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
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

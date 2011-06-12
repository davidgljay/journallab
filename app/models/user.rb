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
                               

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

#Validationville

	validates :name,  :presence => true,
		:length => { :within => 3..50 }
	validates :email, :presence => true,
		:format   => { :with => email_regex },
		:uniqueness => { :case_sensitive => false }
	validates :password, :presence => true,
		:confirmation => true,
		:length => { :within => 6..30 }  

  before_save :encrypt_password

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

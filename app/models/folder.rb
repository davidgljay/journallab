class Folder < ActiveRecord::Base
  attr_accessible :description, :name, :user_id
  
  belongs_to :user
  has_many :notes

  validates :name,  :presence => true,
		:length => { :within => 1..50 }
end

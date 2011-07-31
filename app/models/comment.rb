class Comment < ActiveRecord::Base

attr_accessible :text

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :assertion
belongs_to :comment

has_many :comments

#Validations
   validates :text, :presence => true

end

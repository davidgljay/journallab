class Comment < ActiveRecord::Base

attr_accessible :text

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :assertion
belongs_to :comment
belongs_to :question

has_many :comments
has_many :votes

#Validations
   validates :text, :presence => true

   #validates_associated :user

   validates_inclusion_of :form, :in => %w( comment reply qcomment )

 
end

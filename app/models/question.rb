class Question < ActiveRecord::Base

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :assertion
belongs_to :question

#A question owned by another question is an answer.
has_many :questions
has_many :comments
has_many :votes

#Validations
   validates :text, :presence => true


end

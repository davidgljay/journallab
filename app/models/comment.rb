class Comment < ActiveRecord::Base

attr_accessible :text

belongs_to :paper

#Validations
   validates :text, :presence => true

end

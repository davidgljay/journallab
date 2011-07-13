class Assertion < ActiveRecord::Base
attr_accessible :text

belongs_to :paper
belongs_to :user

#Validations
   validates :text, :presence => true,
                    :length => { :maximum => 300 }


end

class Assertion < ActiveRecord::Base
attr_accessible :text

belongs_to :paper
belongs_to :user
belongs_to :fig
belongs_to :figsection

#Validations
   validates :text, :presence => true,
                    :length => { :maximum => 300 }
   validates :user_id, :presence => true

end

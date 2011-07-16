class Fig < ActiveRecord::Base

belongs_to :paper
has_many :figsections

end

class Figsection < ActiveRecord::Base

belongs_to :fig

has_many :assertions

validates :fig_id, :presence => true

end

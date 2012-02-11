class Sumreq < ActiveRecord::Base

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :get_paper, :class_name => "Paper"
belongs_to :group

validates :user_id, :presence => true, :uniqueness => {:scope => [:paper_id, :fig_id, :figsection_id] } 

end

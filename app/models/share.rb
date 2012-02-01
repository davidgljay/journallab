class Share < ActiveRecord::Base

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :meta_paper, :class_name => "Paper"
belongs_to :group

validates :user_id, :presence => true

end

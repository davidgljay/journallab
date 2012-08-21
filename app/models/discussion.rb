class Discussion < ActiveRecord::Base

belongs_to :user, :class_name => "User"
belongs_to :group, :class_name => "Group"
belongs_to :paper, :class_name => "Paper"

validates :group_id, :presence => true

end

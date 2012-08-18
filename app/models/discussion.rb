class Discussion < ActiveRecord::Base

has_one :user, :class_name => "User"
belongs_to :group, :class_name => "Group"
belongs_to :paper, :class_name => "Paper"

validates :group_id, :presence => true

end

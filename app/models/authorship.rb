class Authorship < ActiveRecord::Base

belongs_to :author, :class_name => "Author"
belongs_to :paper, :class_name => "Paper"

end

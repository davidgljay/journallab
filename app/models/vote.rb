class Vote < ActiveRecord::Base

attr_accessible :get_paper_id

belongs_to :get_paper, :class_name => "Paper"
belongs_to :user
belongs_to :assertion
belongs_to :question
belongs_to :comment
belongs_to :vote_for, :class_name => "User"

validates :user_id, :presence => true, :uniqueness => {:scope => [:question_id, :comment_id, :assertion_id] } 

def owner
    if comment
       comment
    elsif question
       question
    elsif assertion
       assertion
    end
end

def set_get_paper
	self.get_paper_id = owner.get_paper.id
	self.save
	get_paper
end

end

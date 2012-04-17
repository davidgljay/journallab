class Vote < ActiveRecord::Base

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

end

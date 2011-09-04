class Vote < ActiveRecord::Base

belongs_to :user
belongs_to :assertion
belongs_to :question
belongs_to :comment

validates :user_id, :presence => true, :uniqueness => {:scope => [:question_id, :comment_id, :assertion_id] } 

end
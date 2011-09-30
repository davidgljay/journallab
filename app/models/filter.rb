class Filter < ActiveRecord::Base

# This class serves as a switchboard between groups and papers, assertions, comments and questions.
# It indicates which of the above are visible to a particular group.
# State indicates the state of a filter:
# 1 = Public
# 2 = Group
# 3 = Private
# The filter state of a paper controls what a group can see for that paper.
# Paper state = Private: members can only see their own question/comments.
# Paper state = Group: members can see group comments and private comments
# Paper state = Public: members can see group, private, and public comments

belongs_to :group, :class_name => "Group"
belongs_to :paper, :class_name => "Paper"
belongs_to :comment, :class_name => "Comment"
belongs_to :question, :class_name => "Question"
belongs_to :assertion, :class_name => "Assertion"

validates :group_id, :presence => true


end

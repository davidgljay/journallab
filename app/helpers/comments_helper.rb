module CommentsHelper

def boxtext(reply_to)
	reply_to ? 'Leave a reply.' : 'Please explain your reaction (optional).'
end

def addtl_comments(owner, comment)
  (owner.comments + comment.owner.comments + comment.comments).uniq.count-1
end

end

module CommentsHelper

def boxtext(reply_to)
	reply_to ? 'Leave a reply.' : 'Leave a comment.'
end

end

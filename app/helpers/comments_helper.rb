module CommentsHelper

def boxtext(reply_to)
	reply_to ? 'Leave a reply.' : 'Please explain your reaction (optional).'
end

end

module ApplicationHelper

  #Generate a title on a per-page basis
    def title
	base_title = "Understand Question Contribute"
	if @title.nil?
	  base_title
	else
	  "#{base_title} | #{@title}"
	end
    end
end



module ApplicationHelper

  #Generate a title on a per-page basis
    def title
	base_title = "The Journal Lab"
	if @title.nil?
	  base_title
	else
	  "#{base_title} | #{@title}"
	end
    end
end



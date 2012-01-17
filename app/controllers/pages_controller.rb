class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in? && !current_user.groups.empty?
      @group = current_user.groups.last
    else
      @group = Group.new
    end

    @feed = []
    if @group.category == "lab"
      @group.feed.each do |item|
          discussion = item.user.comments.where("created_at > ?", item.updated_at - 1.day) + item.user.questions.where("created_at > ?", item.updated_at - 1.day)
          discussed = discussion.select{|d| d.created_at > (item.updated_at - 1.day)}.map{|c| c.get_paper}.include?(item.paper)
          summarized = item.user.assertions.where("created_at > ?", item.updated_at - 1.day).map{|a| a.get_paper}.include?(item.paper) 
          if discussed and summarized
            text = 'viewed, discussed and summarized the paper'
            bold = true
          elsif discussed
            text = 'viewed and discussed the paper'
            bold = true
          elsif summarized
            text = 'viewed and summarized the paper'
            bold
          else
             text = 'viewed the paper'
          end
          @feed << [item.user, text, item.paper, item.updated_at, bold]
      end
    end
    # If it's a class
    if @group.category == "class"
       @classdates = []
       @general = []
       @papers = []
       @group.papers.each do |p|
           @papers[p.id] = p
       end
       @instructors = @group.memberships.all.select{|m| m.lead}.map{|m| m.user}
       @group.filters.all.each do |f|
         if f.paper_id != nil && f.date != nil
           @classdates << [f.paper_id, f.date, f.supplementary]
         elsif f.date.nil? && f.paper_id != nil
           @general << f.paper
         end
       end
       @classdates.sort!{|x,y| x[1] + x[2].object_id.minutes <=> y[1] + y[2].object_id.minutes}
     end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end

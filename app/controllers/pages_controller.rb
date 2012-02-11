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
        if item.class == Visit
          discussion = item.user.comments.where("created_at > ?", item.updated_at - 1.day) + item.user.questions.where("created_at > ?", item.updated_at - 1.day)
          discussed = discussion.map{|c| c.get_paper}.include?(item.paper)
          last_discussion = discussion.select{|d| d.get_paper == item.paper}.last
          summarized = item.user.assertions.where("created_at > ?", item.updated_at - 1.day).map{|a| a.get_paper}.include?(item.paper) 
          if discussed and summarized
            text = 'discussed and summarized the paper'
            bold = true
          elsif discussed
            text = 'discussed the paper'
            bold = true
          elsif summarized
            text = 'summarized the paper'
            bold = false
          else
            text = 'viewed the paper'
          end
          paper = item.paper
          if discussed 
            sharetext = last_discussion.text
          else
            sharetext = nil
          end
        elsif item.class == Share
          text = reftext(item)
          sharetext = item.text
          bold = true
          paper = item.meta_paper 
         end
        @feed << [item.user, text, paper, item.updated_at, bold, sharetext]
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
  
  def reftext(item)
    if !item.paper.nil?
     text = 'shared the paper'
    elsif !item.fig.nil?
     text = 'shared Figure ' + item.fig.num.to_s + ' of the paper'
    elsif !item.figsection.nil?
     text = 'shared Figure ' + item.figsection.fig.num.to_s + ', Section ' + item.figsection.letter(item.figsection.num) + ' of the paper'
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

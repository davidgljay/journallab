class PagesController < ApplicationController

before_filter :admin_user,   :only => [:dashboard]

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
        if item.class == Comment || item.class == Question
    #      discussion = item.user.comments.where("created_at > ?", item.updated_at - 1.day) + item.user.questions.where("created_at > ?", item.updated_at - 1.day)
    #      discussed = discussion.map{|c| c.get_paper}.include?(item.paper)
    #      last_discussion = discussion.select{|d| d.get_paper == item.paper}.last
    #      summarized = item.user.assertions.where("created_at > ?", item.updated_at - 1.day).map{|a| a.get_paper}.include?(item.paper) 
            text = 'discussed the paper'
            bold = false
            sharetext = item.text
            paper = item.get_paper
         elsif item.class == Assertion
            text = 'summarized the paper'
            bold = false
            sharetext = item.text
            paper = item.get_paper
         elsif item.class == Share
            text = reftext(item)
            sharetext = item.text
            bold = false
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

  def dashboard
    require 'groups_helper'
    @title = "Dashboard"
    @vanity= [["Comments",graph_by_day(Comment.where('created_at > ?', Time.now - 1.month))], ["Questions",graph_by_day(Question.where('created_at > ?', Time.now - 1.month))], ["Summaries",graph_by_day(Assertion.where('created_at > ?', Time.now - 1.month))],["Views", graph_by_day(Visit.where('created_at > ?', Time.now - 1.month))]]
    #@ratios= [["Comments per Visit", graph_by_day(
  end

end

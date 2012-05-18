class PagesController < ApplicationController

before_filter :admin_user,   :only => [:dashboard]

  def home
    @title = "Home"
	if user_signed_in?
	    @group = current_user.get_group
	    @feed = []
	    if @group.category == "lab"
	    	@group.feed.each do |item|
        		if item.class == Comment || item.class == Question
            			text = item.owner.class == Paper ? "left a #{item.class.to_s.downcase} on the overall paper:":"left a #{item.class.to_s.downcase} on #{item.owner.shortname}:"		
            			bold = false
            			sharetext = item.text
            			paper = item.get_paper
         		elsif item.class == Assertion
        			text = item.owner.class == Paper ? "left a summary of the overall paper:":"left a summary of #{item.owner.shortname}:"		
            			bold = false
				sharetext = item.text
				paper = item.get_paper
         		elsif item.class == Share
            			text = reftext(item)
            			sharetext = item.text
            			bold = false
            			paper = item.get_paper 
         		end
        	@feed << [item.user, text, paper, item.updated_at, bold, item]
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
    @vanity = [["Comments",graph_by_day(Comment.where('created_at > ?', Time.now - 1.month))], ["Questions",graph_by_day(Question.where('created_at > ?', Time.now - 1.month))], ["Summaries",graph_by_day(Assertion.where('created_at > ?', Time.now - 1.month))],["Unique Views", graph_by_day(Visit.where('created_at > ?', Time.now - 1.month))]]
    start = @vanity.map{|a| a[1].map{|coord| coord[0]}.min}.min
    finish = @vanity.map{|a| a[1].map{|coord| coord[0]}.max}.max
    # First, get the full range of days covered by the graph
    @range = dayrange(start, finish)
    @nods_per_discussion = histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.votes.count})
    @replies_per_discussion =  histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.comments.count + q.questions.count})
    @nod_discussion_ratio = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count}.inject{|sum, n| sum + n}, Question.where('created_at > ?', Time.now - 1.month).map{|c| c.votes.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ?', Time.now - 1.month).count])
    @reply_discussion_ratio = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count}.inject{|sum, n| sum + n}, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|c| c.comments.count + c.questions.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).count])
    @action_pageview__ratio = make_ratio([Comment.where('created_at > ?', Time.now - 1.month).count, Question.where('created_at > ?', Time.now - 1.month).count, Vote.where('created_at > ?', Time.now - 1.month).count],[Visit.where('updated_at > ?', Time.now - 1.month).map{|v| v.count}.inject{|sum, n| sum + n}])
  end

#
# Analytics functions for the dashboard (and eventually for other places.)
#

   # Creates an array of days from "start" to "finish"
   def dayrange(start, finish)
     if start > finish
      s = start
      start = finish
      finish = s
     end
     days = [start]
     day = start + 1.day
     while day <= finish
      days << day
      day += 1.day
     end
     days
   end

   # Creates a graph of ratios
   # Turns [[[day1,x1], [day2,x2]],[[day1,y1]]] into [[day1, x1/y1],[day2,0]]

   def make_ratio_graph(array1, array2)
     if array1.empty? || array2.empty?
	ratio = [[Time.now],[0]] 
     else
        days = dayrange([array1[0][0] + 1.day, array2[0][0] + 1.day].min,[array1[0][-1], array2[0][-1]].max)
     	ratio = [days,[]]
     	days.each do |day|
     		# This may need to change due to change in array structure
      		x = array1[0].map{|a| a.midnight}.include?(day) ? array1[1][array1[0].index(day)] : 0
      		y = array2[0].map{|a| a.midnight}.include?(day) ? array2[1][array2[0].index(day)] : 0
      		float = y == 0 ? 0 : (x.to_f/y.to_f)
      		ratio[1] << [float]
     	end
      end
     ratio
   end

   #Accepts two arrays of integers and spits back a float ratio

   def make_ratio(array1, array2)
     if array1.empty? || array2.empty? || 
	0 
     else
        array1.compact.inject(0){|sum, item| sum + item}.to_f/array2.compact.inject(0){|sum, item| sum + item}.to_f
     end
   end

   #Takes a 2D array
   def export_data(array, name = "data")
     CSV.open("public/data/" + name + "_" + Time.now.strftime("%m_%d_%Y_%H:%M:%S") + ".csv", "w") do |csv|
      csv << array
     end
   end

   #Takes an array, returns a frequency array by day
   def graph_by_day(array)
     if array.empty?
	graph = [[Time.now, 0]]
     else
     	array.sort!{|x,y| x.created_at <=> y.created_at}
     	finish = array.last.created_at + 1.day
     	start = array.first.created_at -1.day
     	days = []
     	day = start.midnight
        while day < finish.midnight
       		days << day
       		day += 1.day
        end
        graph = days.map{|day| [day, array.select{|object| object.created_at > day && object.created_at < day + 1.day}.count]}
     end
    end

    #Histogram
    def histogram(array)
     histo = array.uniq.map{|unit| [unit, array.count{|x| x == unit}]}.sort{|x,y| x[0]<=>y[0]}
    end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end



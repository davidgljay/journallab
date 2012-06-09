class PagesController < ApplicationController

before_filter :admin_user,   :only => [:dashboard]

  def home
    	@title = "Home"
	@group = Group.find(1)
	if signed_in?
	    	@feed = @group.prep_feed
		@follows  = current_user.follows
		@newfollow = current_user.follows.new
	end
  end

  def feedswitch
	if params[:switchto].first(8) == "journal_"
		@switchto_render = "journal"
		@switchto = params[:switchto]
		@journal = Journal.find_by_name(params[:switchto][8..-1])
		@nav_language = @journal.name
	elsif params[:switchto].first(7) == "follow_"
		@switchto_render = "follow"
		@switchto = params[:switchto]
		@follow = Follow.find(params[:switchto][7..-1].to_i)
		@nav_language = @follow.name
		@group = Group.find(1)
	else
		nav_language = {"most_viewed" => "Popular Papers", "updates" => "Latest Activity", "iccr" => "Welcome"}
		@switchto = params[:switchto]
		@switchto_render = @switchto
		@group = Group.find(1)
		@feed = @group.prep_feed
		@nav_language = nav_language[@switchto]
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
    @vanity = [["Comments",graph_by_day(Comment.where('created_at > ?', Time.now - 1.month))], ["Questions",graph_by_day(Question.where('created_at > ?', Time.now - 1.month))], ["Summaries",graph_by_day(Assertion.where('created_at > ?', Time.now - 1.month))],["Unique Views", graph_by_day(Visit.where('created_at > ?', Time.now - 1.month))],["Users", graph_by_day(User.where('created_at > ?', Time.now - 1.month))],["Custom Feeds", graph_by_day(Follow.where('created_at > ?', Time.now - 1.month))]]
    start = @vanity.map{|a| a[1].map{|coord| coord[0]}.min}.min
    finish = @vanity.map{|a| a[1].map{|coord| coord[0]}.max}.max
    # First, get the full range of days covered by the graph
    @range = dayrange(start, finish)
    @nods_per_discussion = histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.votes.count})
    @replies_per_discussion =  histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.comments.count + q.questions.count})
    @nod_discussion_ratio = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count}.inject{|sum, n| sum + n}, Question.where('created_at > ?', Time.now - 1.month).map{|c| c.votes.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ?', Time.now - 1.month).count])
    @reply_discussion_ratio = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count}.inject{|sum, n| sum + n}, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|c| c.comments.count + c.questions.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).count])
    @action_pageview__ratio = make_ratio([Comment.where('created_at > ?', Time.now - 1.month).count, Question.where('created_at > ?', Time.now - 1.month).count, Vote.where('created_at > ?', Time.now - 1.month).count],[Visit.where('updated_at > ?', Time.now - 1.month).map{|v| v.count}.inject{|sum, n| sum + n}])
    @total_users = [["Users",graph_total_by_day(User.where('created_at > ?', Time.now - 1.year))]]

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
     if array1.empty? || array2.empty?
	result = 0 
     else
        result = array1.compact.inject(0){|sum, item| sum + item}.to_f/array2.compact.inject(0){|sum, item| sum + item}.to_f
     end
     result
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

    def graph_total_by_day(array)
	total = graph_by_day(array)
	yesterday = 0
	total.each do |t|
		t[1] += yesterday
		yesterday = t[1]
	end
	total
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



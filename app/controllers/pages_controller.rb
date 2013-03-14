class PagesController < ApplicationController

  before_filter :admin_user,   :only => [:dashboard]

  def home
    @title = "Home"
    if signed_in?
      @user = current_user
      @jclubs = @user.groups.select{|g| g.category == 'jclub' && !g.current_discussion.nil?}
      @groups = current_user.groups.select{|g| g.category == 'jclub'}
      @follows  = @user.follows.all
      @user.check_feedhash
      @feedhash = @user.feedhash.to_a

      #If there is a follow, load that.
      if @follows.count > 0
        @follow = @follows.first
        @latest_visit = @follow.latest_visit
        if @follow.latest_search
          @feed = @follow.feed
          @recent_activity = @follow.recent_activity
        else
          @feed = Paper.new.search_pubmed(@follow.search_term) if @follow && @feed.empty?
          @recent_activity = nil
        end

        #If there are no feeds but there is a journal club, load that.
      elsif !@jclubs.empty? && @follows.empty?
        if @jclubs.first.current_discussion
          @paper = @jclubs.first.current_discussion.paper
          @jclubs.delay.each do |j|
            j.memberships.select{|m| m.user == current_user}.first.visits.create(:user => current_user, :visit_type => 'feed')			end
          @heatmap = @paper.heatmap
          @heatmap_overview = @paper.heatmap_overview
          @reaction_map = @paper.reaction_map
        end
      end
      @newfollow = current_user.follows.new
      @welcome_screen = false

    end
  end

  def welcome
    if params[:temp_follows].nil? || params[:temp_follows].empty?
      flash[:notice] = 'Enter a few of your research interests to get started.'
    else
      @title = "Welcome"
      @follows = Follow.new.create_temp(params[:temp_follows])
      @feedhash = []
      @follows.each do |f|
        newcount = f.newcount == 0 ? Paper.new.pubmed_search_count(f.search_term, Date.new(1900,1,1)) : f.newcount
        @feedhash << {:id => f.id, :name => f.name, :newcount => newcount, :recent_activity => f.recent_activity.count, :type => 'follow', :css_class => f.css_class}
      end
      @follow = @follows.first
      @feed = @follow.feed
      @jclubs = []
      @groups = []
      @newuser = User.new
      @welcome_screen = true
    end
    render :action => "home"
  end

  def feedswitch
    if params[:switchto].first(7) == "follow_"
      @switchto_render = "follow"
      @switchto = params[:switchto]
      @follow = Follow.find(params[:switchto][7..-1].to_i)
      @latest_visit = @follow.latest_visit
      @recent_activity = @follow.recent_activity
      @follow.visits.create(:user => current_user, :visit_type => 'feed') if signed_in?
      @follow.delay.save
      if @follow.latest_search.nil? || @follow.latest_search.empty?
        @feed = Paper.new.search_pubmed(@follow.search_term)
        @recent_activity = []
      else
        @feed = @follow.feed
      end

      @follow.save
      @nav_language = @follow.name
      @groups = current_user.groups if signed_in?
    else #If rendering a front page discussion
      @switchto = params[:switchto]
      @switchto_render = "discussion"
      @group = Group.find(@switchto[5..-1].to_i)
      if signed_in?
        @membership = @group.memberships.select{|m| m.user == current_user}[0]
        @membership.visits.create(:user => current_user, :visit_type => 'feed')
        @membership.save
      end
      @nav_language = @group.shortname
      @paper = @group.current_discussion.paper

      @heatmap = @paper.heatmap
      @heatmap_overview = @paper.heatmap_overview
      @reaction_map = @paper.reaction_map
      @groups = current_user.groups if signed_in?
    end
    current_user.delay.set_feedhash if signed_in?
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

    @vanity = [["Comments",graph_by_day(Comment.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))], ["Reactions",graph_by_day(Reaction.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))], ["Summaries",graph_by_day(Assertion.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))],["Users", graph_by_day(User.where('created_at > ? ', Time.now - 1.month))],["Custom Feeds", graph_by_day(Follow.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))]]

    @views = [["Papers", graph_by_day(Visit.where("created_at > ? AND visit_type = 'paper' AND user_id <> 1 AND user_id <> 2 AND user_id <> 85", Time.now - 1.month))], ["Comments", graph_by_day(Visit.where("created_at > ? AND visit_type = 'comment' AND user_id <> 1 AND user_id <> 2 AND user_id <> 85", Time.now - 1.month))], ["Feeds", graph_by_day(Visit.where("created_at > ? AND visit_type = 'feed' AND user_id <> 1 AND user_id <> 2 AND user_id <> 85", Time.now - 1.month))]]


    #@nods_per_discussion = histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.votes.count})
    #@replies_per_discussion =  histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.comments.count + q.questions.count})
    @nod_discussion_ratio = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count}.inject{|sum, n| sum + n}, Question.where('created_at > ?', Time.now - 1.month).map{|c| c.votes.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ?', Time.now - 1.month).count])
    @reply_discussion_ratio = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count}.inject{|sum, n| sum + n}, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|c| c.comments.count + c.questions.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).count])
    @action_pageview__ratio = make_ratio([Comment.where('created_at > ?', Time.now - 1.month).count, Question.where('created_at > ?', Time.now - 1.month).count, Vote.where('created_at > ?', Time.now - 1.month).count],[Visit.where('created_at > ?', Time.now - 1.month).count])
    @total_users = [["Users",graph_total_by_day(User.all)]]
    @active_users = Visit.all.select{|v| v.user}.select{|v| v.created_at.to_date != v.user.created_at.to_date && v.created_at > Time.now - 1.month}.map{|v| v.user}.uniq
    @returning_this_month = @active_users.select{|u| u.created_at > Time.now - 1.month}.count
    @registered_this_month = User.all.select{|u| u.created_at > Time.now - 1. month}.count
    @visits_per_user = histogram(User.all.map{|u| u.visits.count})
    @discussion_per_user = histogram(User.all.map{|u| u.reactions.count + u.comments.count})

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
      start = array.first.created_at - 1.day
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
    redirect = true
    if signed_in?
      if current_user.admin
        redirect = false
      end
    end
    redirect_to(root_path) if redirect
  end


end



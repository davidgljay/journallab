class PagesController < ApplicationController

  before_filter :admin_user,   :only => [:dashboard, :manual_refresh]

  def home
    @title = "Open Peer Review"
    if signed_in?
      @user = current_user
      @jclubs = @user.groups.select{|g| g.category == 'jclub' && !g.current_discussion.nil?}
      @groups = current_user.groups.select{|g| g.category == 'jclub'}
      @follows  = @user.follows.all
      @user.check_feedhash
      @feedhash = @user.feedhash.to_a
      if @user.check_orientation
        flash[:success] = User.orientation_msg[@user.orientationhash[:complete]]
      end
      @step = @user.orientationhash[:step]
      @complete = @user.orientationhash[:complete]
      @user.visits.create(:visit_type => 'homefeeds')

=begin
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
          @onfeed = true
          @group = @jclubs.first
          @leads = @group.leads
          @heatmap = @paper.heatmap
          @heatmap_overview = @paper.heatmap_overview
          @reaction_map = @paper.reaction_map
          @groups = current_user.groups if signed_in?
        end
      end
=end
      @newfollow = current_user.follows.new
      @welcome_screen = false

    else
      @newuser = User.new
      a = Analysis.find_by_description('recent_discussions')
      @recent_discussions = a.nil? ? Analysis.new.recent_discussions : a.cache
      Visit.create(:visit_type => 'homepage')
    end
  end

  def homeswitch
    @switchto = params[:switchto]
    if @switchto == 'discussion'
      @recent_discussions = Analysis.find_by_description('recent_discussions').cache
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
    if signed_in?
      @folders = current_user.folders
    end
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
    elsif params[:switchto].first(5) == "group" #If rendering a front page discussion
      @switchto = params[:switchto]
      @switchto_render = "discussion"
      @group = Group.find(@switchto[5..-1].to_i)
      @leads = @group.leads
      if signed_in?
        @membership = @group.memberships.select{|m| m.user == current_user}[0]
        @membership.visits.create(:user => current_user, :visit_type => 'feed')
        @membership.save
      end
      @nav_language = @group.shortname
      @paper = @group.current_discussion.paper
      @onfeed = true
      @heatmap = @paper.heatmap
      @heatmap_overview = @paper.heatmap_overview
      @reaction_map = @paper.reaction_map
      @groups = current_user.groups if signed_in?
    else
      @switchto = params[:switchto]
      @switchto_render = "welcome"
      @nav_language = "Welcome"
      @user = current_user
      if @user.check_orientation
        flash[:success] = User.orientation_msg[@user.orientationhash[:complete]]
      end
      @step = @user.orientationhash[:step]
      @complete = @user.orientationhash[:complete]
    end
    current_user.delay.set_feedhash if signed_in?
  end

  def recent_activity
    @title = "Recent Activity"
    @follow = Follow.find_by_follow_type('public_latest_comments')
    @numcomments = (Comment.all + Reaction.all + Assertion.all).select{|c| c.created_at > Time.now - 1.month}
  end

  def sitemap
    @papers = []
    Paper.all.each do |p|
      @papers << {:loc => "http://www.journallab.org/papers/#{p.id}", :lastmod => p.latest_activity.to_date.to_s }
    end
    render :template => 'pages/sitemap.xml.builder', :formats => [:xml], :handlers => :builder, :layout => false
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


  #Experiments for A/B Testing

  def var1
    @newuser = User.new
    @title = "Home"
    render 'pages/experiments/var1'
  end

  def report
    @title = "Germline stem cells in the postnatal mammalian ovary"
    @discussions = Paper.prepSlideshow([Paper.find(510), Paper.find(511)])
  end


#Takes a 2D array
  def export_data(array, name = "data")
    CSV.open("public/data/" + name + "_" + Time.now.strftime("%m_%d_%Y_%H:%M:%S") + ".csv", "w") do |csv|
      csv << array
    end
  end

  def manual_refresh
    @flash = 'Feeds have been manually refreshed.'
    Follow.delay.update_all_feeds
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



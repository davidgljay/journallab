class GroupsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :is_group_lead, :only => [:remove]

  def show
    @group = Group.find_by_urlname(params[:urlname])

    if @group.category == "jclub"
      @title = @group.name
      @onfeed = false
      @leads = @group.memberships.select{|m| m.lead}.map{|m| m.user}
      if signed_in?
        @group.visits.create(:user => current_user, :visit_type => 'group')
        @group.save
      end
      if @group.current_discussion
        @paper = @group.current_discussion.paper

        @heatmap = @paper.heatmap
        @heatmap_overview = @paper.heatmap_overview
        @reaction_map = @paper.reaction_map
      end
      @groups = current_user.groups if signed_in?
    end


    #Show a group page for a class
    #This is outdated code, keeping it in case it's relevant in the future.
    if @group.category == "class"
      @papers = []
      @classdates = []
      @general = []
      # Create a hash of papers
      @group.papers.each do |p|
        @papers[p.id] = p
      end

      # Create a list of instructors
      @instructors = @group.memberships.all.select{|m| m.lead}.map{|m| m.user}

      # Create a list of classdates and sort by date.
      @group.filters.all.each do |f|
        if f.paper_id != nil && f.date != nil
          @classdates << [f.paper_id, f.date, f.supplementary]
        elsif f.date.nil? && f.paper_id != nil
          @general << f.paper
        end
      end
      @classdates.sort!{|x,y| x[1] + x[2].object_id.minutes <=> y[1] + y[2].object_id.minutes}
    end


    respond_to do |format|
      format.html
    end
  end

  def remove
    @group = Group.find_by_urlname(params[:urlname])
    @user = User.find(params[:u_id])
    @group.remove(@user)
    flash[:success] = @user.name + " has been removed from " + @group.name
    redirect_to root_path
  end

  def join
    @group = Group.find_by_urlname(params[:urlname])
    @user = current_user
    @group.add(@user)
    flash[:success] = "Congratulations! You have joined the discussion group " + @group.name
    redirect_to root_path
  end

  def leave
    @group = Group.find_by_urlname(params[:urlname])
    @user = current_user
    @group.users = @group.users - [@user]
    @group.save
    flash[:success] = "You have left the discussion group " + @group.name
    redirect_to root_path
  end

  def discuss
    @group = Group.find_by_urlname(params[:urlname])
    @user = current_user
    @paper = Paper.find(params[:paper_id])
    if @group.leads.include?(@user)
      @group.discuss(@paper, @user)
      flash[:success] = "This paper will now appear in the tab marked " + @group.name
    end
    redirect_to @paper
  end

  def undiscuss
    @user = current_user
    @groups = @user.memberships.select{|m| m.lead }.map{|m| m.group}
    @paper = Paper.find(params[:paper_id])
    @groups.each do |group|
      group.undiscuss(@paper)
      flash[:success] = "This paper has been removed from your #{'group'.pluralize(@groups.count)}."
    end
    redirect_to @paper
  end

  def image_upload
    group = Group.find_by_urlname(params[:urlname])
    if params[:group]
      group.image = params[:group][:group_image]
      group.save
    end
    redirect_to '/groups/' + group.urlname
  end

  def remove_image
    group = Group.find_by_urlname(params[:urlname])
    group.image = nil
    group.save
    redirect_to :back
  end

  private
  def is_group_lead
    @group = Group.find_by_urlname(params[:urlname])
    @group.leads.include?(current_user)
  end


end

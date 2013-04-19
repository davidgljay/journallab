class FollowsController < ApplicationController
  before_filter :authenticate_user!, :except => [:viewswitch]
  before_filter :admin_user, :only => [:index]


  def create
    follow = Follow.new(params[:follow])
    follow.search_term = params[:follow][:search_term]
    follow.name = follow.search_term
    follow.update_feed
    follow.save
    current_user.set_feedhash
    redirect_to root_path
  end

  def destroy
    @follow_id = params[:follow]
    @follow = Follow.find(@follow_id)
    @follow.destroy
    current_user.set_feedhash
    respond_to do |format|
      format.js
    end

  end

  def viewswitch
    @switchto = params[:switchto]
    @follow = Follow.find(params[:follow])
    if @switchto == 'comments'
      @feed = @follow.comments_feed
      @recent_activity = @follow.recent_activity
    else
      @feed = @follow.feed
      @recent_activity = @follow.recent_activity
    end
    respond_to do |format|
      format.js
    end
  end

  # Get a CSV of users and their follows. Disabling for now.
  #def index
  #  respond_to do |format|
  #    format.csv { send_data Follow.to_csv }
  #  end
  #end

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

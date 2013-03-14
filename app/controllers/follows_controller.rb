class FollowsController < ApplicationController
  before_filter :authenticate_user!, :except => [:viewswitch]


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
end

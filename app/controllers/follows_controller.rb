class FollowsController < ApplicationController
before_filter :authenticate_user!, :except => :temp_follow


  def create
	follow = Follow.new(params[:follow])
	follow.search_term = params[:follow][:search_term]
	follow.name = follow.search_term
	follow.update_feed
	follow.save
	redirect_to root_path 
  end
end

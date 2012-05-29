class FollowsController < ApplicationController
before_filter :authenticate_user!

  def create
	follow = Follow.new(params[:follow])
	follow.search_term = params[:follow][:search_term]
	follow.name = follow.search_term
	if !params[:journal].empty?
		follow.search_term = params[:journal] + "[journal]"
		follow.name = params[:journal]
	end
	follow.save
	follow.update_feed
	redirect_to root_path 
  end

end

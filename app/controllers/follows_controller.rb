class FollowsController < ApplicationController
  def create
	follow = Follow.new(params[:follow])
	follow.search_term = params[:follow][:search_term]
	follow.name = follow.search_term
	if !params[:journal].empty?
		follow.search_term = params[:journal] + "[journal]"
		follow.name = params[:journal]
	end
	follow.save
	redirect_to root_path 
  end

end

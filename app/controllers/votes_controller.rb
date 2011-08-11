class VotesController < ApplicationController
  def create
    @candidate = params[:vote][:type].constantize.find(params[:vote][:id])
    current_user.vote!(@candidate)
    respond_to do |format|
      format.html { redirect_to @candidate }
      format.js
    end
  end

end

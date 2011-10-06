class VotesController < ApplicationController
  def create
    @candidate = params[:vote][:type].constantize.find(params[:vote][:id])
    current_user.vote!(@candidate)
    paper = @candidate.get_paper
    @numvotes = @candidate.votes.count
    respond_to do |format|
      format.html { redirect_to paper }
      format.js
    end
  end

end

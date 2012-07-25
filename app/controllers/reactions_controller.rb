class ReactionsController < ApplicationController
  def create
	@reaction = params[:reaction] 
  end

  def destroy
	@reaction = Reaction.find(params[:id])
	if current_user == @reaction.user || current_user == admin
		@reaction.destroy
	end
  end

end

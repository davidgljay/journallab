class FoldersController < ApplicationController
before_filter :authenticate_user!

  def index
	@user = current_user
	@folders = @user.folders.map{|f| [f, f.notes.map{|n| n.about}.uniq]} 
	respond_to do |format|
		format.html
	end
  end

  def list
	@paper = Paper.find(params[:paper])
    respond_to do |format|
      format.js
    end
  end
end

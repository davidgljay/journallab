class FoldersController < ApplicationController
before_filter :authenticate_user!

  def index
	@user = current_user
  @folders = @user.folders
	@folders_list = @user.folders.map{|f| [f, f.notes.map{|n| n.about}.uniq.map{|p| p.to_hash}]}
	respond_to do |format|
		format.html
	end
  end

  def list
	@pubmed_id = params[:pubmed_id]
    respond_to do |format|
      format.js
    end
  end
end

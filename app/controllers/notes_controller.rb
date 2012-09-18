class NotesController < ApplicationController
before_filter :authenticate_user!

  def create
	@pubmed_id = params[:pubmed_id]
	paper = Paper.find_or_create_by_pubmed_id(@pubmed_id)
	if params[:folder]
		@newfolder = true
		@folder = Folder.new(:name => params[:folder])
		@folder.user = current_user
		@folder.save		
		@note = @folder.notes.new
		@note.about = paper
		@note.user = current_user
		@note.save
	else
		@note = Note.new(params[:note])
		@note.about = paper
		@note.user = current_user
		@note.save
		@folder = @note.folder
	end
	if paper.title.nil?
		paper.delay.lookup_info
	end
        respond_to do |format|
		format.js
	end
  end

  def destroy
	@folder = Folder.find(params[:folder_id])
	@paper = Paper.find(params[:paper_id])
	@folder.notes.select{|n| n.about == @paper}.each{|n| n.destroy}
        respond_to do |format|
		format.js
	end
  end
end

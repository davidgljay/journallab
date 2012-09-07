class ReactionsController < ApplicationController
before_filter :authenticate_user!

  def create
	@reaction = Reaction.new(params[:reaction])
	@reaction.user = current_user
	@owner = params[:about_type].constantize.find(params[:about_id])
	@reaction.about = @owner
	if @reaction.save
		@newreaction = true
		@paper = @reaction.get_paper
		@paper.add_heat(@owner)
		@paper.save
		@reaction_map = @paper.reaction_map
		@heatmap = @paper.heatmap
	else
		@newreaction = false
	end
        respond_to do |format|
		format.js
	end
  end

def quickform
	@name = params[:name].empty? ? params[:commit] : params[:name] 
	@reaction = Reaction.new(:name => @name)
	@reaction.user = current_user
	@paper = Paper.find(params[:paper])
	if params[:fig].empty? || params[:fig] == '2, 3C, etc.'
		@owner = @paper
		@reload = @paper.figs.empty? && @paper.comments.empty? && @paper.questions.empty?
	elsif params[:fig].last.match('[a-z]').nil?
		@reload = params[:fig].to_i > @paper.figs.count
		@paper.build_figs(params[:fig].to_i) if @reload
		@owner = @paper.figs.select{|f| f.num ==  params[:fig].to_i}.first
	else
		fignum = params[:fig].chop.to_i
		sectnum = Figsection.new.number(params[:fig].last)
		@reload = fignum > @paper.figs.count
		@paper.build_figs(fignum)
		fig = @paper.figs.select{|f| f.num ==  fignum}.first
		@reload = sectnum > fig.figsections.count
		fig.build_figsections(sectnum)
		@paper.reset_heatmap
		@owner = fig.figsections.select{|s| s.num ==  sectnum}.first	
	end
	@reaction.about = @owner
	
	if @reaction.save
		@newreaction = true
		@paper = @reaction.get_paper
		@paper.add_heat(@owner)
		@paper.save
	else
		@newreaction = false
	end
	@reaction_map = @paper.reaction_map
	@heatmap = @paper.heatmap
        respond_to do |format|
		format.js
	end
end


  def destroy
	@reaction = Reaction.find(params[:id])
	if current_user == @reaction.user || current_user == admin
		@reaction.destroy
	end
	@reaction.get_paper.delay.save
  end

end

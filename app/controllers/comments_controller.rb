class CommentsController < ApplicationController
before_filter :authenticate_user!


 #Used to render a list in the papers view.
  def list
    	@owner = params[:owner].constantize.find(params[:id])
    	@group = current_user.get_group
    	@mode = params[:mode].to_i
	
	#Comments used to be visible only to groups. We're switching things so that they're always visible and just semi-anonymous. 
 	@comments = @owner.comments.all #.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    	@owner_type = params[:owner]
    	respond_to do |format|
        	format.js 
     	end
  end

  # POST /comments
  # POST /comments.xml
  def create
    	@comment = Comment.new(:text => params[:comment][:text])
    	@mode = params[:mode].to_i
	if params[:comment][:assertion_id]
    		@comment.assertion = Assertion.find(params[:comment][:assertion_id])
    	end
    	@comment.user = current_user
    	@comment.form = params[:comment][:form]
    	@group = current_user.get_group
    	if params[:comment][:form] == "reply"
       		@comment.comment = Comment.find(params[:comment][:reply_to])
    		@owner = @comment.owner
    	elsif params[:comment][:form] == "qcomment"
       		@comment.question = Question.find(params[:comment][:reply_to])
       		@questions = @comment.owner.questions.all.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    		@owner = @comment.owner
    	else
		@owner = params[:owner_class].constantize.find(params[:owner_id])
		if @owner.class == Paper
			@comment.paper = @owner
		elsif @owner.class == Fig
    	 		@comment.fig = @owner
    		elsif @owner.class == Figsection
			@comment.figsection = @owner
		end
    	end
    	@comment.save
    	@paper = @owner.get_paper
    	@paper.add_heat(@owner)
    	@heatmap = @paper.heatmap
    	@group.make_filter(@comment, params[:mode])
    	@comments = @owner.comments.all #.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    	respond_to do |format|
      		if @comment.save
         	#Send an e-mail if the comment is a reply
         		if !@comment.comment.nil? || !@comment.question.nil?
            		#Send the comment to the original commenter and anyone else in the thread, except the current poster
            			@thread = @comment.comment ? @comment.comment : @comment.question
            			([@thread.user] + @thread.comments.map{|c| c.user}).uniq.each do |u|
              				Mailer.comment_response(@comment, u).deliver if u != @comment.user && u.receive_mail?
            			end
         		end
         	format.js
        	format.html { redirect_to @paper }
      		end
    	end
  end

# A form for quickly entering comments and questions.

def quickform
	@paper = Paper.find(params[:paper])
	@user = current_user
	@group = @user.get_group
	@mode = params[:mode].to_i
	@form = params[:form]
	if params[:fig].empty?
		@owner = @paper
		@reload = false
	elsif params[:fig].last.match('[a-z]').nil?
		@reload = params[:fig].to_i > @paper.figs.count
		@paper.build_figs(params[:fig].to_i)
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
	if @form == 'comment'
		@comment = @owner.comments.create!(:text => params[:text], :form => 'comment', :user_id => @user.id)
		@comment.save
		@group.make_filter(@comment, @mode)
		@comments = @owner.comments.all.select{|c| @group.let_through_filter?(c,current_user, @mode)}
	elsif @form == 'question'
		@comment = @owner.questions.create!(:text => params[:text], :user_id => @user.id)
		@comment.save
		@group.make_filter(@comment, @mode)
		@questions = @owner.questions.all.select{|c| @group.let_through_filter?(c,current_user, @mode)}
	end
	@paper.add_heat(@owner)
	@heatmap = @paper.heatmap
	respond_to do |format|
		format.js
		format.html { redirect_to @paper }
	end	
end

end

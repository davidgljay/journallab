class QuestionsController < ApplicationController
before_filter :authenticate_user!

  def list
    @owner = params[:owner].constantize.find(params[:id])
    @group = current_user.get_group
    @mode = params[:mode].to_i
    @questions = @owner.questions.all #.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    @owner_type = params[:owner]
    respond_to do |format|
        format.js
     end
  end

  def create
    if params[:question][:format] == 'question'
       @question = Question.new(:text => params[:question][:text])
       @owner = params[:owner_class].constantize.find(params[:owner_id])
	 if @owner.class == Paper
	 	@question.paper = @owner
	 elsif @owner.class == Fig
    	 	@question.fig = @owner
    	 elsif @owner.class == Figsection
		@question.figsection = @owner
	 end

    elsif params[:question][:format] == 'answer'
        @question = Question.new(:text => params[:question][:text])
        @question.question = Question.find(params[:question][:reply_to])
    end
    @mode = params[:mode].to_i
    @question.user = current_user
    @question.set_get_paper
    @question.assertion = params[:question][:assertion_id] ? Assertion.find(params[:question][:assertion_id]) : nil
    # Replies and answers are associated with assertions (for counting purposes), but NOT with figs, papers, etc.
    @paper = @question.get_paper
    @owner = @question.owner
    @group = current_user.get_group
    @paper.heatmap
    @paper.add_heat(@owner)
    @heatmap = @paper.heatmap
    if @question.user.groups.empty?
       @question.is_public = true
    elsif @mode == 2
       @group.make_group(@question)
    elsif @mode == 1
       @group.make_public(@question)
    end
    @questions = @owner.questions.all #.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    respond_to do |format|
      if @question.save
         if !@question.question.nil?
            @thread = @question.question
            #Send the comment to the original commenter and anyone else in the thread, except the current poster
            ([@thread.user] + @thread.questions.map{|q| q.user} + @thread.comments.map{|c| c.user}).uniq.each do |u|
               Mailer.comment_response(@question, u).deliver if u != @question.user && u.receive_mail?
            end
         end
        format.js
        format.html { redirect_to @paper }
#        format.xml  { render :xml => @comment, :status => :created, :location => @question }
#      else
#        flash[:error] = "Please enter a comment."
#        format.html { redirect_to :back }
#        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

end

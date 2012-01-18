class CommentsController < ApplicationController
before_filter :authenticate


 #Used to render a list in the papers view.
  def list
    @owner = params[:owner].constantize.find(params[:id])
    @group = current_user.groups.last
    @mode = params[:mode].to_i
    @comments = @owner.comments.all.select{|c| @group.let_through_filter?(c,current_user, @mode)}
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
    @comment.assertion = Assertion.find(params[:comment][:assertion_id])
    assertion = @comment.assertion
    @comment.user = current_user
    @comment.form = params[:comment][:form]
    @group = current_user.groups.last
    # Replies are associated with assertions (for counting purposes), but NOT with figs, papers, etc.
    url = '/papers/' + assertion.get_paper.id.to_s
    if params[:comment][:form] == "reply"
       @comment.comment = Comment.find(params[:comment][:reply_to])
    elsif params[:comment][:form] == "qcomment"
       @comment.question = Question.find(params[:comment][:reply_to])
       @questions = @comment.owner.questions.all.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    elsif @comment.paper = assertion.paper
    elsif @comment.fig = assertion.fig
    elsif @comment.figsection = assertion.figsection
    end
    @comment.save
    @owner = @comment.owner
    @heatmap = @owner.get_paper.heatmap
    if @comment.user.groups.empty?
       @comment.is_public = true
    elsif @mode == 2
       @group.make_group(@comment)
    elsif @mode == 1
       @group.make_public(@comment)
    end
    @comments = @owner.comments.all.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    respond_to do |format|
      if @comment.save
         format.js
#        flash[:success] = 'Comment added, excellent point.'
        format.html { redirect_to url }
#        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
#      else
#        flash[:error] = "Please enter a comment."
#        format.html { redirect_to :back }
#        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

end

class CommentsController < ApplicationController
before_filter :authenticate


 #Used to render a list in the papers view.
  def list
    @parent = params[:parent].constantize.find(params[:id])
    @comments = @parent.comments.all
    @parent_type = params[:parent]
    respond_to do |format|
        format.js 
     end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(:text => params[:comment][:text])
    @comment.assertion = Assertion.find(params[:comment][:assertion_id])
    assertion = @comment.assertion
    @comment.user = current_user
    @comment.form = params[:comment][:form]
    # Replies are associated with assertions (for counting purposes), but NOT with figs, papers, etc.
    url = '/papers/' + assertion.get_paper.id.to_s
    if params[:comment][:form] == "reply"
       @comment.comment = Comment.find(params[:comment][:reply_to])
    elsif params[:comment][:form] == "qcomment"
       @comment.question = Question.find(params[:comment][:reply_to])
    elsif @comment.paper = assertion.paper
    elsif @comment.fig = assertion.fig
    elsif @comment.figsection = assertion.figsection
    end

    respond_to do |format|
      if @comment.save
        flash[:success] = 'Comment added, excellent point.'
        format.html { redirect_to url }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = "Please enter a comment."
        format.html { redirect_to :back }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

end

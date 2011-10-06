class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  # Savign this for when I want to show a comment detail.
  def show
    @comment = Comment.find(params[:id])
    @assertion = @comment.assertion
    @comments = @comment.comments.all
    @newcomment = @assertion.comments.build
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
  end
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @comment }
#    end
#  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @assertion = @comment.assertion
  end


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
    url = '/papers/' + assertion.find_paper.id.to_s
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
        format.html { redirect_to url, :notice => 'Comment was successfully created.' }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = "Please enter a comment."
        format.html { redirect_to :back }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /comments/1/reply
  def reply
    @comment = Comment.find(params[:id])
    @reply = @comment.comments.build
    @assertion = @comment.assertion
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end

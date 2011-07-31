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
  def show
    if params[:about] == "papers"
       @owner = Paper.find(params[:id])
    elsif params[:about] == "figs"
       @owner = Fig.find(params[:id])
    elsif params[:about] == "figsections"
       @owner = Figsection.find(params[:id])
    end
    @assertion = @owner.latest_assertion
    @newcomment = @owner.comments.build
    @comments = @owner.comments.all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  #def new
  #  @comment = Comment.new

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

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.assertion = Assertion.find(params[:comment][:assertion_id])
    assertion = @comment.assertion
    @comment.user = current_user
    # Replies are associated with assertions (for counting purposes), but NOT with figs, papers, etc.
    url = '/' + assertion.about + 's/' + assertion.owner_id.to_s + '/comments'
    if params[:comment][:reply_to]
       @comment.comment = Comment.find(params[:comment][:reply_to]) 
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

class QuestionsController < ApplicationController
  def show
  end

  def answer
    @question = Question.find(params[:id])
    @answer = @question.questions.build
    @assertion = @question.assertion
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @question = Question.new
  end

  def comment
    @question = Question.find(params[:id])
    @comment = @question.comments.build
    @assertion = @question.assertion
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def create
    if params[:question][:format] == 'question'
       @question = Question.new(:text => params[:question][:text])
       notice = "Question added."
    elsif params[:question][:format] == 'answer'
       @question = Question.new(:text => params[:question][:text])
       @question.question = Question.find(params[:question][:reply_to])
       notice = "Thank you for your answer."
    elsif params[:question][:format] == 'comment'
      @question = Comment.new(:text => params[:question][:text])
      notice = "Your comment has been added."
    end
    @question.assertion = Assertion.find(params[:question][:assertion_id])
    assertion = @question.assertion
    @question.user = current_user
    # Replies and answers are associated with assertions (for counting purposes), but NOT with figs, papers, etc.
    url = '/' + assertion.about + 's/' + assertion.owner_id.to_s + '/discussion'
    unless @question.question
      if @question.paper = assertion.paper
      elsif @question.fig = assertion.fig
      elsif @question.figsection = assertion.figsection
      end
    end

    respond_to do |format|
      if @question.save
        format.html { redirect_to url, :notice => notice }
        format.xml  { render :xml => @comment, :status => :created, :location => @question }
      else
        flash[:error] = "Please enter a comment."
        format.html { redirect_to :back }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

end

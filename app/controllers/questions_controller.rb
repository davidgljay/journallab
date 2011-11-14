class QuestionsController < ApplicationController
before_filter :authenticate

  def list
    @owner = params[:owner].constantize.find(params[:id])
    @questions = @owner.questions.all
    @owner_type = params[:owner]
    respond_to do |format|
        format.js
     end
  end

  def create
    if params[:question][:format] == 'question'
       @question = Question.new(:text => params[:question][:text])
       flash[:success] = "Question added."
    elsif params[:question][:format] == 'answer'
       @question = Question.new(:text => params[:question][:text])
       @question.question = Question.find(params[:question][:reply_to])
       flash[:success] = "Thank you for your answer."
    elsif params[:question][:format] == 'comment'
      @question = Comment.new(:text => params[:question][:text])
      flash[:success] = "Your comment has been added."
    end
    @question.user = current_user
    @question.save
    @question.assertion = Assertion.find(params[:question][:assertion_id])
    assertion = @question.assertion
    # Replies and answers are associated with assertions (for counting purposes), but NOT with figs, papers, etc.
    url = '/papers/' + assertion.get_paper.id.to_s
    unless @question.question
      if @question.paper = assertion.paper
      elsif @question.fig = assertion.fig
      elsif @question.figsection = assertion.figsection
      end
    end
    @question.save
    @owner = @question.owner
    @questions = @owner.questions
    @heatmap = @owner.get_paper.heatmap
    @question.user.groups.last.make_group(@question)

    respond_to do |format|
      if @question.save
         format.js
        format.html { redirect_to url }
#        format.xml  { render :xml => @comment, :status => :created, :location => @question }
#      else
#        flash[:error] = "Please enter a comment."
#        format.html { redirect_to :back }
#        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

end

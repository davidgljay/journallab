class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:list]

  #Used to render a list in the papers view.
  def list
    @owner = params[:owner].constantize.find(params[:id])
    @mode = params[:mode].to_i
    if signed_in?
        @owner.visits.create(:user => current_user, :visit_type => 'comment')
    end
    #Comments used to be visible only to groups. We're switching things so that they're always visible and just semi-anonymous.
    if @owner.class == Fig
      @comments = @owner.meta_comments
    else
      @comments = @owner.comments.all
    end
    @owner_type = params[:owner]
    @paper = @owner.get_paper
    respond_to do |format|
      format.js
    end
  end

  # POST /comments
  # Activates create.js which makes the comment appear w/out a page reload.
  def create
    @comment = Comment.new(:text => params[:comment][:text], :anonymous => params[:comment][:anonymous])
    # Disabled until I bring back more complex privacy
    #@mode = params[:mode].to_i
    #if params[:comment][:assertion_id]
    #	@comment.assertion = Assertion.find(params[:comment][:assertion_id])
    #end
    @comment.user = current_user
    @comment.form = params[:comment][:form]
    @groups = current_user.groups
    if params[:comment][:form] == "reply"
      @comment.comment = Comment.find(params[:comment][:reply_to])
      @owner = @comment.owner
    else
      @owner = params[:owner_class].constantize.find(params[:owner_id])
      # At some point, come in and make comments polymorphic so that this can be avoided
      if @owner.class == Paper
        @comment.paper = @owner
      elsif @owner.class == Fig
        @comment.fig = @owner
      elsif @owner.class == Figsection
        @comment.figsection = @owner
      end
    end
    @paper = @owner.get_paper
    @comment.get_paper = @paper
    @comment.save
    @paper.add_heat(@owner)
    @heatmap = @paper.heatmap
    if @owner.class == Fig
      @comments = @owner.meta_comments
    else
      @comments = @owner.comments.all
    end
    @comment.delay.feedify
    respond_to do |format|
      if @comment.save
        #Send an e-mail if the comment is a reply
        if !@comment.comment.nil? || !@comment.question.nil?
          #Send the comment to the original commenter and anyone else in the thread, except the current poster
          @thread = @comment.comment ? @comment.comment : @comment.question
          ([@thread.user] + @thread.comments.map{|c| c.user}).uniq.each do |u|
            Mailer.comment_response(@comment, u).deliver if u != @comment.user && u.receive_mail?('reply')
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
    @group = current_user.get_group
    @mode = params[:mode].to_i
    @form = params[:form]
    if params[:fig].empty?
      @owner = @paper
      @reload = @paper.figs.empty? && @paper.comments.empty? && @paper.questions.empty?
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
      @comment = @owner.comments.create!(:text => params[:text], :form => 'comment', :user_id => @user.id, :anonymous => params[:anonymous])
      @comment.save
      @group.make_filter(@comment, @mode)
      @comments = @owner.comments.all#.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    elsif @form == 'question'
      @comment = @owner.questions.create!(:text => params[:text], :user_id => @user.id, :anonymous => params[:anonymous])
      @comment.save
      @group.make_filter(@comment, @mode)
      @questions = @owner.questions.all#.select{|c| @group.let_through_filter?(c,current_user, @mode)}
    end
    current_user.get_group.feed_add(@comment)
    @paper.add_heat(@owner)
    @heatmap = @paper.heatmap
    respond_to do |format|
      format.js
      format.html { redirect_to @paper }
    end
  end

end

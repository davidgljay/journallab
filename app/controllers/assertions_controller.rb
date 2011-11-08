class AssertionsController < ApplicationController
before_filter :authenticate
before_filter :authorized_user_or_admin,   :only => [:destroy, :edit, :update]

  def list
    @owner = params[:owner].constantize.find(params[:id])
    @assertions = @owner.assertions.all
    @owner_type = params[:owner]
    if signed_in? && !current_user.groups.empty? 
      @group = current_user.groups.last
    else
      @group = Group.new
    end 
    respond_to do |format|
        format.js 
     end
  end

  # POST /assertions/new
  def new
    @about = params[:about].constantize.find(params[:id])
    @assertion = @about.assertions.build
    if signed_in? && !current_user.groups.empty? 
      @group = current_user.groups.last
    else
      @group = Group.new
    end    

    respond_to do |format|
      format.js 
   end
end

  # GET /assertions/improve/1
  # A method to improve assertions
  def improve
    @title = "Improve Assertion"
    @oldassertion = Assertion.find(params[:id])
    if @oldassertion.about == 'paper'
       @paper = @oldassertion.paper
       @about = "paper"
       @history = @paper.assertions.all
       @assertion = @paper.assertions.build
    elsif @oldassertion.about == 'fig'
       @fig = @oldassertion.fig
       @about = "figure"
       @history = @fig.assertions.all
       @assertion = @fig.assertions.build
    elsif @oldassertion.about == 'figsection'
       @figsection = @oldassertion.figsection
       @history = @figsection.assertions.all
       @about = "section"
       @assertion = @figsection.assertions.build
    end
      @history = @history.sort_by{|a| a.votes.count}.reverse
  end

  # GET /assertions/1/edit
  def edit
    @assertion = Assertion.find(params[:id])
    if @assertion.about == 'paper'
       @paper = @assertion.paper
       @about = "paper"
       @history = @paper.assertions.all
    elsif @assertion.about == 'fig'
       @fig = @assertion.fig
       @about = "figure"
       @history = @fig.assertions.all
    elsif @assertion.about == 'figsection'
       @figsection = @assertion.figsection
       @history = @figsection.assertions.all
       @about = "section"
    end
  end

  # POST /assertions
  # POST /assertions.xml
  def create
    @assertion = Assertion.new(params[:assertion])
    @assertion.user_id = current_user.id
    if @assertion.about == "paper"
        @assertion.paper = Paper.find(params[:assertion][:owner_id])
        @paper = @assertion.paper
    elsif @assertion.about == "fig"
        @assertion.fig = Fig.find(params[:assertion][:owner_id])
        @paper = @assertion.fig.paper
    elsif @assertion.about == "figsection"
        @assertion.figsection = Figsection.find(params[:assertion][:owner_id])
        @paper = @assertion.figsection.fig.paper
    end
   
  #Check to make sure that something was entered.
   if @assertion.text.include?('What is the core conclusion') || @assertion.method.include?('What principle methods')
    flash[:error] = "Please enter a conclusion and method."
    save = false
   else

    @assertion.is_public = true
    @assertion.alt_approach = @assertion.alt_approach == 'What are alternate approaches?' ? nil : @assertion.alt_approach
    save = @assertion.save
    flash[:success] = 'Summary entered, thanks for your contribution.'
    save = true
   end

  # Add a privacy setting if the user is part of a class that's reading this paper.
    if @group = current_user.groups.last
      if @group.category == "class" && :save
         @group.make_group(@assertion)
         @assertion.is_public = false
      end
    end


    #Items from papers controller to be able to render assertions. Should be identical to papers controller until I can figure out how to mirror...
    @owner = @assertion.owner
    @heatmap = @assertion.get_paper.heatmap
    if signed_in? && !current_user.groups.empty? 
      @group = current_user.groups.last
    else
      @group = Group.new
    end
    @numfig_select = Array.new
    30.times do |i| 
      @numfig_select << [(i+1).to_s, i+1 ]
    end

    respond_to do |format|
       format.js
       format.html { redirect_to(@paper) }
#      format.xml  { render :xml => @assertion, :status => :created, :location => @assertion }
    end
  end

  # PUT /assertions/1
  # PUT /assertions/1.xml
  def update
    @assertion = Assertion.find(params[:id])

    respond_to do |format|
      if @assertion.update_attributes(params[:assertion])
        flash[:success] = 'Assertion was successfully updated.'
        format.html { redirect_to(@assertion)  }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assertion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assertions/1
  # DELETE /assertions/1.xml
  def destroy
    @assertion = Assertion.find(params[:id])
    @assertion.destroy

    respond_to do |format|
      format.html { redirect_to(assertions_url) }
      format.xml  { head :ok }
    end
  end

  private

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

  def authorized_user_or_admin
      @assertion = Assertion.find(params[:id])
      redirect_to root_path unless current_user?(@assertion.user) || current_user.admin?
  end
end

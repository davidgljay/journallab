class AssertionsController < ApplicationController
before_filter :authenticate
before_filter :authorized_user_or_admin,   :only => [:destroy, :edit, :update]


  # GET /assertions
  # GET /assertions.xml
  def index
    @assertions = Assertion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assertions }
    end
  end

  # GET /assertions/1
  # GET /assertions/1.xml
  def show
    @assertion = Assertion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assertion }
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

  # GET /assertions/new
  # GET /assertions/new.xml
  #def new
  #  @assertion = Assertion.new

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @assertion }
  #  end
  #end

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
  
  #Associate the assertion with the proper figure, figsection, or paper.
    if params[:assertion][:paper_id]
        @assertion.about = "paper"
        @assertion.paper = Paper.find(params[:assertion][:paper_id])
        @assertion.method = params[:assertion][:method]
        url = @assertion.paper
        @assertion.paper.build_figs(params[:numfigs]) 
    elsif params[:assertion][:fig_id] 
        @assertion.about = "fig"
        @assertion.fig = Fig.find(params[:assertion][:fig_id])
        @assertion.method = params[:assertion][:method]
        url = @assertion.fig.paper
        @assertion.fig.build_figsections(params[:numsections]) 
    elsif params[:assertion][:figsection_id]
        @assertion.about = "figsection"
        @assertion.method = params[:assertion][:method]
        @assertion.figsection = Figsection.find(params[:assertion][:figsection_id])
        url = @assertion.figsection.fig.paper 
    end

    respond_to do |format|
      if @assertion.save
        format.html { redirect_to(url, :notice => 'Assertion was successfully created.') }
        format.xml  { render :xml => @assertion, :status => :created, :location => @assertion }
      elsif ur
        format.html { redirect_to(url, :notice => 'Please submit your assertion again.') }
        format.xml  { render :xml => @assertion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assertions/1
  # PUT /assertions/1.xml
  def update
    @assertion = Assertion.find(params[:id])

    respond_to do |format|
      if @assertion.update_attributes(params[:assertion])
        format.html { redirect_to(@assertion, :notice => 'Assertion was successfully updated.') }
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

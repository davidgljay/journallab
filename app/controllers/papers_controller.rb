class PapersController < ApplicationController
before_filter :authenticate, :except => [:show, :index, :lookup]
before_filter :admin_user,   :only => [:destroy, :edit, :update]


  # GET /papers
  # GET /papers.xml
  def index
    @papers = Paper.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end

  # GET /papers/1
  # GET /papers/1.xml
  def show
    @paper = Paper.find(params[:id])
    @core_assertion = @paper.assertions.build if @paper.assertions.empty?
    @heatmap = @paper.heatmap
    #Prep the selection dropdown for selection the # of figs in the paper.  
    @numfig_select = Array.new
    30.times do |i| 
      @numfig_select << [(i+1).to_s, i+1 ]
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/new
  # GET /papers/new.xml
  def new
    @paper = Paper.new

    respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/1/edit
  def edit
    @paper = Paper.find(params[:id])
  end

  # POST /papers
  # POST /papers.xml
  def create
    @paper = Paper.new(params[:paper])

    respond_to do |format|
      if @paper.save
        format.html { redirect_to(@paper, :notice => 'Paper was successfully created.') }
        format.xml  { render :xml => @paper, :status => :created, :location => @paper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /papers/1
  # PUT /papers/1.xml
  def update
    @paper = Paper.find(params[:id])

    respond_to do |format|
      if @paper.update_attributes(params[:paper])
        format.html { redirect_to(@paper, :notice => 'Paper was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.xml
  def destroy
    @paper = Paper.find(params[:id])
    @paper.destroy

    respond_to do |format|
      format.html { redirect_to(papers_url) }
      format.xml  { head :ok }
    end
  end

#Look up a paper by it's pubmed ID. If it doesn't exist create a new one and get its info from pubmed.
  def lookup
    @paper = Paper.find_by_pubmed_id(params[:pubmed_id])
    if @paper.nil?
       @paper = Paper.create(:pubmed_id => params[:pubmed_id])
       @paper.lookup_info
    end
    if flash[:error].nil?
      redirect_to @paper
    else
      redirect_to 'pages#home'
    end
  end    

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

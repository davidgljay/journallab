class PapersController < ApplicationController
before_filter :authenticate
before_filter :admin_user,   :only => [:destroy, :index, :edit, :update]


  # GET /papers
  # GET /papers.xml
  def index
    @papers = Paper.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end

# This is legacy code
#  def discussion
#    if params[:about] == "papers"
#       @owner = Paper.find(params[:id])
#    elsif params[:about] == "figs"
#       @owner = Fig.find(params[:id])
#    elsif params[:about] == "figsections"
#       @owner = Figsection.find(params[:id])
#    end
#    @assertion = @owner.latest_assertion
#    @newcomment = @owner.comments.build
#    @newquestion = @owner.questions.build
#    @comments = @owner.comments.all.sort_by{|a| a.votes.count}.reverse
#    @questions = @owner.questions.all.sort_by{|a| a.votes.count}.reverse
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @comment }
#    end
#  end

  # GET /papers/1
  # GET /papers/1.xml
  def show
    @paper = Paper.find(params[:id])
    if signed_in?
       @paper.visits.build(:user_id => current_user.id).save
    end
    if @paper.authors.empty? || @paper.authors.nil?
       @paper.extract_authors
    end

    @heatmap = @paper.heatmap
    # For now I'll assume that users are only in one group. If they aren't then I'll use a generic empty group to stop things from breaking.
    if signed_in? && !current_user.groups.empty? 
      @group = current_user.groups.last
    else
      @group = Group.new
    end

    @classdates = []
    @group.filters.each do |f|
      unless f.date.nil?
        @classdates << f.date
      end
    end
    @classdates.sort!{|x,y| x <=> y}.uniq! unless @classdates.nil?
  
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

 def grab_images
     @paper = Paper.find(params[:id])
     allowed_users = Group.find(2).users
     if allowed_users.include?(current_user)
        if @paper.grab_images == 0
           flash[:notice] = "Looked for images on Medline, but this paper doesn't have any. Sorry."
         else
             flash[:success] = "Grabbed images from Medline."
         end
     else
         flash[:error] = "You are not authorized to use this function, sorry."
     end
     redirect_to(@paper)
  end

#Look up a paper by it's pubmed ID. If it doesn't exist create a new one and get its info from pubmed.
  def lookup
    search = params[:pubmed_id].strip
    if search.to_i.to_s == search
      @paper = Paper.find_by_pubmed_id(search)
      if @paper.nil?
         @paper = Paper.create(:pubmed_id => search)
         @paper.lookup_info
      end
      if flash[:error].nil?
        redirect_to @paper
      else
        redirect_to 'pages#home'
      end
    # If the search term is not a pubmed ID, look it up.
    elsif search.to_i.to_s != search
      url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=' + search.gsub(/[' ']/, "+").gsub(/['.']/, "+")
      doc = Nokogiri::XML(open(url))
      pids = doc.xpath("//IdList/Id")
      @search_results = []
      pids.each do |pid|
         paper = Paper.find_by_pubmed_id(pid.text)
         if paper.nil?
            paper = Paper.create!(:pubmed_id => pid.text)
            paper.lookup_info
         end
         unless paper.title.nil?
            @search_results << paper
         end
      end
      respond_to do |format|
        format.html
        format.xml
      end
     end
  end    

  def build_figs
      @paper = Paper.find(params[:id])
      @paper.build_figs(params[:num]) 
      redirect_to @paper
  end
     

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

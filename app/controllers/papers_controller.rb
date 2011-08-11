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

  def discussion
    if params[:about] == "papers"
       @owner = Paper.find(params[:id])
    elsif params[:about] == "figs"
       @owner = Fig.find(params[:id])
    elsif params[:about] == "figsections"
       @owner = Figsection.find(params[:id])
    end
    @assertion = @owner.latest_assertion
    @newcomment = @owner.comments.build
    @newquestion = @owner.questions.build
    @comments = @owner.comments.all.sort_by{|a| a.votes.count}.reverse
    @questions = @owner.questions.all.sort_by{|a| a.votes.count}.reverse
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
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
      url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=' + search.gsub(/[' ']/, "+")
      dirty_xml = Net::HTTP.get_response(URI.parse(url)).body
      clean_xml = CGI::unescapeHTML(dirty_xml).gsub(/\n/," ").gsub!(/>\s*</, "><")
      clean_xml.gsub!(/[&]/, 'and')
      data = REXML::Document.new(clean_xml)
      pids = data.root.elements["IdList"]
      @search_results = []
      pids.each do |pid|
         paper = Paper.find_by_pubmed_id(pid.text)
         if paper.nil?
            paper = Paper.create(:pubmed_id => pid.text)
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

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

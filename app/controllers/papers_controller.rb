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

  # GET /papers/1
  # GET /papers/1.xml
  def show
    	@paper = Paper.find(params[:id])
    	if signed_in?
       		visit = Visit.where(:user_id => current_user.id, :paper_id => @paper.id).first
       		visit ||= Visit.create(:user_id => current_user.id, :paper_id => @paper.id, :count => 0)
       		visit.count ||= 0
       		visit.count += 1 unless visit.updated_at > Time.now - 3.hours
       		visit.save
    	end
	if @paper.authors.empty? || @paper.authors.nil?
       		@paper.extract_authors
       		@paper.count_figs
	end
	@heatmap = @paper.heatmap
	@heatmap_overview = @paper.heatmap_overview
   # For now I'll assume that users are only in one group. If they aren't then I'll use a generic empty group to stop things from breaking.
  	@group = current_user.get_group

    #@classdates = []
    #@group.filters.each do |f|
    #  unless f.date.nil?
    #    @classdates << f.date
    #  end
    #end
    #@classdates.sort!{|x,y| x <=> y}.uniq! unless @classdates.nil?
  
    #Prep the selection dropdown for selection the # of figs in the paper.  
    	@numfig_select = Array.new
    	30.times do |i| 
      		@numfig_select << [(i+1).to_s, i+1 ]
   	end

    #Are you viewing in group or public mode?
	if params[:mode] == "public"
       		@mode = 1
    	else
       		@mode = 2
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

  # GET /papers/1/m/1
  # For tracking links to paper from e-mail
  def show_from_mail
    @maillog = Maillog.find(params[:m_id])
    @paper = Paper.find(params[:id])
    @maillog.conversiona = Time.now if @maillog.conversiona.nil? && @maillog.about.get_paper == @paper
    @maillog.save
    redirect_to @paper
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
      cleansearch = search.gsub(/[' ']/, "+").gsub(/['.']/, "+")

# Non-alphanumerics are apprently verboden on heroku,,.gsub(/['α']/, "alpha").gsub(/['β']/, "beta").gsub(/['δ']/, "delta").gsub(/['ε']/, "epsilon").gsub(/['ζ']/, "zeta").gsub(/['θ']/, "theta").gsub(/['ι']/, "iota").gsub(/['κ']/, "kappa").gsub(/['λ']/, "lamda").gsub(/['μ']/, "mu").gsub(/['ν']/, "nu").gsub(/['ξ']/, "xi").gsub(/['ο']/, "omicron").gsub(/['π']/, "pi").gsub(/['ρ']/, "rho").gsub(/['Σσς']/, "sigma").gsub(/['Ττ']/, "tau").gsub(/['Υυ']/, "upsilon").gsub(/['Φφ']/, "phi").gsub(/['Χχ']/, "chi").gsub(/['Ψψ']/, "psi").gsub(/['Ωω']/, "omega")

      #Get a list of pubmed IDs for the search terms
      url1 = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=' + cleansearch
      pids = Nokogiri::XML(open(url1)).xpath("//IdList/Id").map{|p| p.text} * ","
      url2 = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' + pids + '&retmode=xml&rettype=abstract'
      data = Nokogiri::XML(open(url2))
      @search_results = []
      data.xpath('//PubmedArticle').count.times do |i|
        pid = data.xpath('//PMID')[i].text
        title = data.xpath('//Article/ArticleTitle')[i].text
        journal = data.xpath('//Journal/Title')[i].text
        pubdate = nil
        day = data.xpath('//PubDate/Day')[i].nil? ? nil : data.xpath('//PubDate/Day')[i].text.to_i
        month = data.xpath('//PubDate/Month')[i].nil? ? nil : monthhash[data.xpath('//PubDate/Month')[i].text]
        year = data.xpath('//PubDate/Year')[i].nil? ? nil : data.xpath('//PubDate/Year')[i].text.to_i
	pubdate = Time.local(year, month, day) if year
        abstract = nil
        unless data.xpath('//Abstract/AbstractText')[i].nil?
        	abstract = data.xpath('//Abstract/AbstractText')[i].text
        end
	# Extract the authors as an array for now. When someone clicks on the paper we'll create records for them.
	authors = []
	data.xpath('//AuthorList/Author').each do |auth|
	     	author = [auth.xpath('ForeName').text, auth.xpath('LastName').text, auth.xpath('Initials').text]
       		authors << Author.new(:firstname => author[0], :lastname => author[1], :initial => author[2])
	end

        paper = Paper.find_by_pubmed_id(pid)  
        if paper.nil?
        	paper = Paper.create!(:pubmed_id => pid, :title => title, :journal => journal, :pubdate => pubdate, :abstract => abstract)
        end
        @search_results << [paper, authors]    
      end
      respond_to do |format|
        format.html
        format.xml
      end
     end
  end    

def monthhash
   monthhash = {
      'Jan' => 1,
      'Feb' => 2,
      'Mar' => 3,
      'Apr' => 4,
      'May' => 5,
      'Jun' => 6,
      'July' => 7,
      'Aug' => 8,
      'Sep' => 9,
      'Oct' => 10,
      'Nov' => 11,
      'Dec' => 12
      }
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

class PapersController < ApplicationController
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
	@paper.visits.create(:user => current_user, :visit_type => 'paper') if signed_in?
	if @paper.visits.empty?
       		@paper.count_figs
	end
	@heatmap = @paper.heatmap
	@heatmap_overview = @paper.heatmap_overview
	@reaction_map = @paper.reaction_map
	@interest = @paper.interest
	#@blogs = @paper.check_blogs
	if signed_in?
		@groups = current_user.groups
		@groups.delay.each {|g| g.most_viewed_add(@paper); g.save;}
	end

    #Prep the selection dropdown for selection the # of figs in the paper.  
    	@numfig_select = Array.new
    	30.times do |i| 
      		@numfig_select << [(i+1).to_s, i+1 ]
   	end

    	#Private and group functionality is being disabled for now, all comments are public.
	#if params[:mode] == "public"
       		@mode = 1
    	#else
       	#	@mode = 2
    	#end
        session[:return_to] = request.fullpath
    	respond_to do |format|
      		format.html # show.html.erb
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
    search = params[:search].strip
    if signed_in?	
	@groups = current_user.groups
    end
    if search.to_i.to_s == search
      @paper = Paper.find_or_create_by_pubmed_id(search)
      if @paper.title.nil?
	@paper.lookup_info
      end
    # If the search term is not a pubmed ID, look it up.
    elsif search.to_i.to_s != search
      @search_results = (Paper.new.search_activity(search) + Paper.new.search_pubmed(search)).uniq
      @history_results = []
      if signed_in?
		@history_results = @search_results & current_user.visited_papers.map{|p| p.to_hash}
	      	@search_results = @search_results - @history_results
      		@search_results.select{|p| p[:latest_activity].nil?}.each {|p| p[:latest_activity] ||= Time.now - 1.month}
      end
      @search_results.sort!{|x,y| y[:latest_activity] <=> x[:latest_activity]}
    end
    if @paper
        redirect_to @paper
    else	
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
      @paper.save
      redirect_to @paper
  end
     

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

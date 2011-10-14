class GroupsController < ApplicationController
before_filter :authenticate

  def show
      @group = Group.find(params[:id])
      if @group.category == "class"
         @papers = []
         @instructors = []
         @classdates = []
         @general = []
         # Create a hash of papers
         @group.papers.each do |p|
           @papers[p.id] = p
         end

         # Create a list of instructors
         @group.memberships.each do |m|
           if m.lead
             @instructors << User.find(m.user_id)
           end
         end

 
         # Create a list of classdates and sort by date.
         @group.filters.all.each do |f|
           if f.paper_id != nil && f.date != nil
             @classdates << [f.paper_id, f.date, f.supplementary]
           elsif f.date.nil? && f.paper_id != nil
             @general << f.paper
           end
         end
         @classdates.sort!{|x,y| x[1] + x[2].object_id.minutes <=> y[1] + y[2].object_id.minutes}
      end
      
      
      respond_to do |format|
      format.html
      end
  end

private
    def logged_in
      redirect_to(signin_path) if not signed_in?
    end

end

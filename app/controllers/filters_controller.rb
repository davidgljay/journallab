class FiltersController < ApplicationController

# This form is specifically for creating filters 

  def create
    @group = Group.find(params[:filter][:group])
    @paper = Paper.find(params[:filter][:paper])
    @group.make_private(@paper, params[:filter][:date], params[:filter][:suplementary])
    respond_to do |format|
      format.html { redirect_to @paper, :notice => "Paper added to class list, oh the learning they'll do..." }
      format.js
    end
  end

  def update
    @group = Group.find(params[:filter][:group])
    @paper = Paper.find(params[:filter][:paper])
    if params[:perm] == 'private'
       @group.make_private(@paper)
    elsif params[:perm] == 'group'
       @group.make_group(@paper)
    elsif params[:perm] == 'public'
       @group.make_public(@paper)
    end
    respond_to do |format|
      format.html { redirect_to @paper, :notice => "Class permissions updated, nice work!" }
      format.js
    end
  end
end

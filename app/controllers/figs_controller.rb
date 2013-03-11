class FigsController < ApplicationController
before_filter :authenticate_user!
before_filter :admin_user,   :only => :destroy

  def build_sections
    fig = Fig.find(params[:id])
    fig.build_figsections(params[:num].to_i)
    fig.paper.save 
    redirect_to fig.paper
  end

  def image_upload
    fig = Fig.find(params[:id])
    fig.image = params[:fig][:fig_image]
    fig.save
    redirect_to fig.paper
  end

def remove_image
  fig = Fig.find(params[:id])
  fig.image = nil
  fig.save
  redirect_to :back
end

private

def admin_user
  redirect_to(root_path) unless current_user.admin?
end

end

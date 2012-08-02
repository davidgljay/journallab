class FigsController < ApplicationController
before_filter :authenticate_user!

  def build_sections
    fig = Fig.find(params[:id])
    fig.build_figsections(params[:num])
    fig.paper.save 
    redirect_to fig.paper
  end

  def image_upload
    fig = Fig.find(params[:id])
    fig.image = params[:fig][:fig_image]
    fig.save
    redirect_to fig.paper
  end

end

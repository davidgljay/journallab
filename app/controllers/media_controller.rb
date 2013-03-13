class MediaController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_user,   :only => [:destroy, :index]


  def create
    @media = Media.new(:link => params[:link])
    @media.paper = Paper.find(params[:paper])
    @media.user = current_user
    @media.save
    if @media.category == 'invalid' || @media.category == nil
      flash[:error] = 'Please enter a valid youtube or slideshare link.'
    else
      flash[:success] = 'Your content has been added to the paper.'
    end
    redirect_to @media.paper
  end

  def destroy
    @media = Media.find(params[:id])
    @media.destroy
    redirect_to :back
  end

  #Show an index of all medias and figs for admins to review
  def index
    @title = 'Review Figs and Embedded Content '
    @medias = Media.all.map{|m| {:item => m, :date => m.created_at, :type => 'media', :paper => m.paper} }
    @figs = Fig.all.select{|f| !f.image.nil?}.map{|f| {:item => f, :date => f.updated_at, :type => 'fig', :paper => f.paper} }
    @list = Kaminari.paginate_array((@medias + @figs).sort{|x,y| y[:date]<=> x[:date]}).page(params[:page]).per(20)
  end

  private

  def admin_user
    redirect = true
    if signed_in?
      if current_user.admin
        redirect = false
      end
    end
    redirect_to(root_path) if redirect
  end

end

class SharesController < ApplicationController
before_filter :authenticate_user!


  def create
    @item = params[:share][:type].constantize.find(params[:share][:id])
    @group = Group.find(params[:share][:group])
    @text = params[:share][:text] 
    @share = @item.shares.create!(:user=> current_user, :text => @text, :get_paper => @item.get_paper, :group => @group)
    @group.feed_add(@share)
    @paper = @item.get_paper
    @numshares = @item.shares.count
    respond_to do |format|
      @group.users.each do |u|
# Disabling share mailer for ISSCR 
#         Mailer.share_notification(@share, u).deliver if u.receive_mail?("share_notification")
      end
      format.js
      format.html { redirect_to @paper }
    end
  end

end

class SharesController < ApplicationController
before_filter :authenticate


  def create
    @item = params[:share][:type].constantize.find(params[:share][:id])
    @group = Group.find(params[:share][:group])
    @text = params[:share][:text] 
    @share = current_user.share!(@item, @group, @text)
    paper = @item.get_paper
    @numshares = @item.shares.count
    respond_to do |format|
      Mailer.share_notification(@share).deliver
      format.js
      format.html { redirect_to paper }
    end
  end

end

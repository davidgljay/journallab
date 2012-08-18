class SharesController < ApplicationController
before_filter :authenticate_user!


  def create
    @item = params[:share][:type].constantize.find(params[:share][:id].to_i)
    @groups = params[:group].to_a.delete_if{|g| g[1] == "0"}.map {|g| Group.find(g[0].to_i)}
    @text = params[:share][:text] 
    @paper = @item.get_paper
    @groups.each do |g|
       @share = @item.shares.create!(:user=> current_user, :text => @text, :get_paper => @item.get_paper, :group => g)
       g.feed_add(@share)
       #g.users.each do |u|
       # Disabling share mailer for ISSCR 
       #  Mailer.delay.share_notification(@share, u).deliver if u.receive_mail?("share_notification")
       #end
    end
    respond_to do |format|
      format.js
      format.html { redirect_to @paper }
    end
  end

end

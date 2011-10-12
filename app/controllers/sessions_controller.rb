class SessionsController < ApplicationController
  def new
     @title = "Sign in"
     @user = User.new
  end

  def create
     user = User.authenticate(params[:session][:email],
			      params[:session][:password])
     if user.nil?
       flash.now[:error] = "Invalid email or password."
       @title = "Sign in"
       @user = User.new
       render 'new'

     else
     if user.groups.first
       url = user.groups.first
     else
       url = root_path
     end
      sign_in user
      redirect_back_or url
     end
  end

  def destroy
    sign_out
    flash[:success] = "You have been signed out."
    redirect_to root_path
  end

end

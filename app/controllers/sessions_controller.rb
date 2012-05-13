class SessionsController < ApplicationController
validate :check_if_verified


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
      url = root_path
      sign_in user
      redirect_back_or url
     end
  end

  def destroy
    sign_out
    flash[:success] = "You have been signed out."
    redirect_to root_path
  end


  private

  def check_if_verified
    errors.add(:base, "You have not yet verified your account") unless attempted_record && attempted_record.verified
  end

end 

end

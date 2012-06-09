class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  # Devise: Where to redirect users once they have logged in
  def after_sign_in_path_for(resource)
    path = session[:return_to] || root_path
    session.delete(:return_to)  # <- Path you want to redirect the user to.
    path
  end

end

class AnalysisController < ApplicationController
  before_filter :admin_user

  def dashboard
    require 'groups_helper'
    @title = "Dashboard"
    @analysis = Analysis.first

  end

  def journals
    @title = "Journal Analysis"
    @analysis = Analysis.find_by_description('journal analysis')
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

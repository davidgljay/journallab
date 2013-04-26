class AnalysisController < ApplicationController
  before_filter :admin_user

  def dashboard
    require 'groups_helper'
    @title = "Dashboard"
    @analysis = Analysis.find_by_description('dashboard')

  end

  def journals
    @title = "Journal Analysis"
    @analysis = Analysis.find_by_description('journal analysis')
  end

  def most_discussed
    @titel = "Most Discussed Papers"
    @analysis = Analysis.new.most_discussed
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

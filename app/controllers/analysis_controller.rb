class AnalysisController < ApplicationController

  def dashboard
    require 'groups_helper'
    @title = "Dashboard"
    @analysis = Analysis.first

  end

  def journals
    @title = "Journal Analysis"
    @analysis = Analysis.find_by_description('journal analysis')
  end

end

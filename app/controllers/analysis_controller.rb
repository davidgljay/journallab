class AnalysisController < ApplicationController

  def dashboard
    require 'groups_helper'
    @title = "Dashboard"
    @analysis = Analysis.first

  end

end

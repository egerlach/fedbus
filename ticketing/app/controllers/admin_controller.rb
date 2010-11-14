class AdminController < ApplicationController
  before_filter permission_required(:view_admin_panel)

  # GET /admin
  def index
  end

end

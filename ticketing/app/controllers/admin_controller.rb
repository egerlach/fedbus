class AdminController < ApplicationController
  before_filter permission_required(:view_admin_panel)

  # GET /admin - Works like this because admin is SINGULAR
  # i.e., there is no index since there is only one.
  def show
  end

end

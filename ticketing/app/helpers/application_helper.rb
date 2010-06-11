# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def login_redirect_path
    login_path(:return_to => request.request_uri)
  end

  def datetime_to_strtime date_time
    date_time.strftime("%H:%M")
  end
end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Returns a login path which will redirect to the currently-shown
  # page once the user has authenticated.
  def login_redirect_path
    login_path(:return_to => request.fullpath)
  end

  def datetime_to_strtime date_time
    date_time.strftime("%H:%M")
  end

  def datetime_to_str date_time
    date_time.strftime("%Y-%m-%d %H:%M")
  end

  def date_to_str date
    date.strftime("%Y-%m-%d")
  end

end

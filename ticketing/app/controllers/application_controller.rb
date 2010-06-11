# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authorization::ControllerMixin
  helper :all # include all helpers, all the time
  helper_method :current_user, :logged_in?, :permission_required

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '793157f216123b9d496ced55a5f76a7d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def store_location(return_to = nil)
    session[:return_to] = return_to || request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to session[:return_to] || default
    session[:return_to] = nil
  end

  def current_user
    @current_user ||=
      if session[:userid]
        User.find_by_userid(session[:userid])
      end
  end

  def logged_in?
    !!current_user
  end

  def login_required
    logged_in? || access_denied
  end

  def access_denied()
    store_location
    if session[:userid]
      redirect_to :new_user
    else
      redirect_to :login
    end
  end
end

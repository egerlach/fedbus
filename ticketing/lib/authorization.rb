module Authorization 
  # Include this mixin in a controller class to make authorization methods available.
  # Most likely, this will simply be included in ApplicationController.
  module ControllerMixin
    # Causes Authorization::ControllerMixin::ClassMethods to be pulled in
    # as class methods.
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Whereas access_denied indicates that the user was not authenticated
    # (and should be redirected to a login page), authorization_denied
    # is called when the user is authenticated, but does not have the
    # appropriate permissions.
    def authorization_denied
      render :template => "errors/authorization_denied", :status => :forbidden
    end

    module ClassMethods

      # Intended to be used with before_filter to ensure that users have
      # the permission required to perform an action.
      #
      # Example:
      #
      #  class MyController < ApplicationController
      #    before_filter permission_required(:eat_cake), :except => [:index, :show]
      #    (...)
      #  end
      def permission_required(permission)
        Proc.new do |controller|
          if controller.logged_in?
            controller.current_user.has_permission?(permission) || controller.authorization_denied
          else
            controller.access_denied
          end
        end
      end

    end
  end
end

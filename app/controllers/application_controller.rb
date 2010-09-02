# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include SslRequirement

  helper :all
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include SessionHelper

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def destroy_session
    if request.request_uri == "/site/index" || request.request_uri == "/"
        unless session[:uuid].nil?
          nameframe = Nameframe.find_by_uuid(session[:uuid])

            nameframe.destroy unless nameframe.nil? || nameframe.has_owner? || nameframe.has_checkout?

        end
        session[:uuid] = nil
        session[:photo_customizations] = nil
    end
  end

  def store_location
    session[:return_to] = request.request_uri unless request.xhr?
  end

  def is_admin
    unless current_user.role.title == 'administrator'
      redirect_to '/'
    end
  end

end

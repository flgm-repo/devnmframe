class SiteController < ApplicationController

  before_filter :destroy_session, :only=>[:index]
  before_filter :login_required, :only=>[:account]

  def index
  end

  def show_login
    render :update do |page|
      page["popup_div"].replace_html :partial=>"show_login"
    end
  end

  def show_forgot
    render :update do |page|
      page["popup_div"].replace_html :partial=>"show_forgot"
    end
  end

  def display_session
    puts session.inspect
  end

  def media
    @files = Dir.glob("public/media_content/*.html") rescue []
    if params[:id].blank?
      @page_title = File.basename(@files.first, '.html') rescue ""
    else
      @page_title = params[:id]
    end
    
    
  end

  def about_us
  end

  def contact
  end
end


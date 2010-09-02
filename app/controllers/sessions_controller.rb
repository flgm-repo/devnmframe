# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  ssl_allowed :new, :create, :destroy, :forgot_password, :login_by_token

  # render new.rhtml
  def new
  end

  def create
    #    return render :text=>params.inspect
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      #      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
      respond_to do |format|
        format.js {
          render :update do |page|
            if session[:return_to]
              if (params[:save_data] && params[:save_data] == "true")
                page.redirect_to saving_data_assets_path
              else
                page.redirect_to session[:return_to]
              end
            else
              page.redirect_to("/")
            end
          end
        }
        format.html {
          redirect_to :root
        }
      end
    else
      respond_to do |format|
        format.js {
          render :update do |page|
            page << "$(\"#fancy_div .div_login_notice\").html(\"Username or password is incorrect!\").show()"
          end
        }
        format.html {
          redirect_to :root
        }
      end
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    old_session = session
    reset_session
    session[:uuid] = old_session[:uuid]
    session[:photo_customizations] = old_session[:photo_customizations]
    session[:return_to] = old_session[:return_to] || root_path
    flash[:notice] = "You have been logged out."
    redirect_to session[:return_to]
  end

  def forgot_password
    @user = User.find_by_email(params[:email])
    unless @user.nil?
      if Notifier.deliver_forgot_password_notification(@user)
        flash[:notice] = "Your password has been sent to your email address!"
      else
        flash[:notice] = "There is some problem with the server please contact Administrator!"
      end
      render :update do |page|
        page.redirect_to session[:return_to]
      end
    else
      #      flash[:notice] = "No account associated with this email address!"
      render :update do |page|
        page << "$(\"#fancy_div .div_forgot_notice\").html(\"No account associated with this email address!\").show()"
      end
    end
  end

  def login_by_token
    user = User.find_by_token(params[:token])
    if user
      self.current_user = user
      redirect_to :edit_my_account
    else
      redirect_to :root
    end
  end
end


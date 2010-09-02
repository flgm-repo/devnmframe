class Admin::SessionsController < Admin::ApplicationController
  # render new.rhtml
  ssl_exceptions
  def new
    if logged_in? && current_user.is_admin?
      render :layout => 'admin'
    else
      render :layout => 'application'
    end
  end

  def create
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
              page.redirect_to session[:return_to]
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
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(new_admin_session_path)
  end

end


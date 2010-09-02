class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  ssl_allowed :new, :create

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    #    @user.password = params[:user][:password]
    @user = User.new(params[:user])
    @user.role = Role.find_by_title('user')
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      respond_to do |format|
        format.js {
          render :update do |page|
            if (params[:save_data] && params[:save_data] == "true")
              page.redirect_to saving_data_assets_path
            else
              page.redirect_to session[:return_to]
            end
          end
        }
        format.html {
            if (params[:save_data] && params[:save_data] == "true")
              redirect_to saving_data_assets_path
            else
              redirect_to session[:return_to]
            end
        }
      end
      flash[:notice] = "Thanks for signing up!"
    else
      respond_to do |format|
        format.js{
          render :update do |page|
            page << "$(\"#fancy_div .div_login_notice\").html(\"Username or password is incorrect!\").show()"
          end
        }
        format.html{
          render :action => 'new'
        }
      end
    end
  end
end


class Admin::UsersController < Admin::ApplicationController
  ssl_exceptions
  before_filter :require_admin_role
  
  def index
   @users = User.all(:include => :role)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.login =  @user.email
    if @user.save
      flash[:notice] = "User Created!"
      redirect_back_or_default admin_users_url
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id]) # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      if params[:user][:password]
        @user.password = params[:user][:password]
        @user.save
      end
      
      flash[:notice] = "User updated!"
      redirect_to admin_user_url
    else
      render :action => :edit
    end
  end
  
  def disable
    @user = User.find(params[:id])
    @user.state = User::STATE_DISABLED
    unless @user == current_user
      if @user.save
        flash[:notice] = 'The user was disabled succesfully!'
        redirect_to :admin_users
      else
        flash[:notice] = 'There was an error trying to disable the user'
        redirect_to :admin_users
      end
    else
      flash[:notice] = "You can't change your own state"
      redirect_to :admin_users
    end
  end

  def enable
    @user = User.find(params[:id])
    unless @user == current_user
      @user.state = User::STATE_ACTIVE
      if @user.save
        flash[:notice] = 'The user was enabled succesfully!'
        redirect_to :admin_users
      else
        flash[:notice] = 'There was an error trying to enable the user'
        redirect_to :admin_users
      end
    else
      flash[:notice] = "You can't change your own state"
      redirect_to :admin_users
    end
  end
end

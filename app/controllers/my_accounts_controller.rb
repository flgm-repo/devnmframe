class MyAccountsController < ApplicationController

  def show
    @user = current_user
    @nameframes = @user.nameframes.limit(3).order('created_at DESC')
    @perpage=10
    @orders = @user.checkouts.paginate :page => params[:page], :per_page => @perpage
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if params[:update_my_account][:password]
      @user.password = params[:update_my_account][:password]
      @user.password_confirmation = params[:update_my_account][:password]
    end
    @user.name = params[:update_my_account][:name]
    if @user.save
      flash[:notice] = "User updated!"
      redirect_to my_account_path
    else
      render :action => :edit
    end
  end

end

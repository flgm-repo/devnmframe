class OrdersController < ApplicationController
  def index
    if params[:find_by] == "delivering"
      @orders = current_user.checkouts.delivering
    elsif params[:find_by] == "enjoy"
      @orders = current_user.checkouts.enjoy
    elsif params[:find_by] == "orders_in_progress"
      @orders = current_user.checkouts.orders_in_progress
    else
      @orders = current_user.checkouts
    end
  end

  def show
    @order = current_user.checkouts.find(params[:id])
    @nameframe = @order.nameframe
    @nameframe_path=@nameframe.get_image_path
    @billing_address = @order.billing
    @shipping_address = @order.shipping    
  end

  def show_as_guest
    if session[:order_completed]
      session[:uuid] = nil
      session[:photo_customizations] = nil
      @order = Checkout.find(session[:order_completed].to_i)
      @nameframe =  @order.nameframe
      @nameframe_path=@nameframe.get_image_path
      @billing_address = @order.billing
      @shipping_address = @order.shipping    
      render "show"
    else
      redirect_to root_path
    end
  end
end


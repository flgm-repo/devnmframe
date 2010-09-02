class Admin::OrderCodesController < Admin::ApplicationController
  ssl_exceptions
  before_filter :require_admin_role
  def index
    @order_codes = FreeNameframeCode.find(:all, :order => "created_at DESC")
  end
  
  def edit
    @order_code = FreeNameframeCode.find(params[:id])
  end
  
  def update
    @order_code = FreeNameframeCode.find(params[:id])
    @order_code.update_attributes(params[:free_nameframe_code])
    if @order_code.save
      redirect_to admin_order_codes_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @order_code = FreeNameframeCode.find(params[:id])
    if @order_code
      @order_code.destroy
      redirect_to admin_order_codes_path
    end
  end
  
  def new
    @order_code = FreeNameframeCode.new
  end
  
  def create
    @order_code = FreeNameframeCode.new(params[:free_nameframe_code])
    if @order_code.save
      redirect_to admin_order_codes_path
    else
      render :action => :new
    end
  end
end

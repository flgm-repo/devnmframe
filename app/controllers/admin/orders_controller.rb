class Admin::OrdersController < Admin::ApplicationController
  
  ssl_exceptions
  before_filter :require_admin_role

  def index
    @perpage=16
    @orders = Checkout.show_asc.archived('0').paginate :page => params[:page], :per_page => @perpage
  end

  def show
    @id=params[:id]
    @nameframe=Nameframe.find_by_id(@id)
    @order=@nameframe.checkout
    @nameframe_path=@nameframe.get_image_path
    @billing_address=Address.find(@order.billing_address_id)
    @shipping_address=Address.find(@order.shipping_address_id)
  end

  def filter
    @perpage=16
    @filter_by=params[:filter_by].to_i
    @order_by=params[:order_by].blank? ? "created_at ASC" : params[:order_by]
    #If we need to show the Archived orders
    @archived=params[:archived]=="true" ? "1" : "0"
    @orders = Checkout.filter(@filter_by, @order_by, @archived).paginate :page => params[:page], :per_page => @perpage
    render 'index', :locals => { :filter_by => @filter_by, :order_by => @order_by, :archived =>@archived }
  end

  def change_status
    id=params[:id]
    status=params[:status]
    @order=Checkout.find_by_id(id)
    @order.update_attribute(:status,status)
    flash[:notice]="Status successfull changed."
    redirect_to :action=>:show , :id=>@order.nameframe_id
  end

  def archive_order
    id=params[:id]
    @order=Checkout.find(id)
    @order.update_attribute(:archived,1)
    flash[:notice]="Order successfull Archived."
    redirect_to :action=>:show , :id=>@order.nameframe_id
  end
  
  def orders_report
    @orders = Checkout.all
    file_name = "Checkout"
    unless @orders.blank?
      respond_to do |format|
        format.xls { send_data @orders.to_xls(:table_to_export => file_name), :filename=> (file_name + ".xls")}
      end
    end
  end

end

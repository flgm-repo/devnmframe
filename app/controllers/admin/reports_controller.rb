class Admin::ReportsController < Admin::ApplicationController
  
  ssl_exceptions
  before_filter :require_admin_role
  
  def orders
    @filter_by=params[:filter_by].to_i
    @order_by=params[:order_by].blank? ? "created_at ASC" : params[:order_by]
    @archived=params[:archived]=="true" ? "1" : "0"
    @orders = Checkout.filter(@filter_by, @order_by, @archived).all
    file_name = "Checkout"
    unless @orders.blank?
      respond_to do |format|
        format.xls { send_data @orders.to_xls(:table_to_export => file_name), :filename=> (file_name + ".xls")}
      end
    else
      redirect_to :controller => :orders, :action => :index
    end    
  end

end
class Admin::HomeController < Admin::ApplicationController

  ssl_exceptions
  before_filter :require_admin_role
  
  def index
    @new_orders=Checkout.newest.archived('0')
    @inprogress_orders=Checkout.orders_in_progress.archived('0')
    @shipped_orders=Checkout.shipped.archived('0')
  end
  
end

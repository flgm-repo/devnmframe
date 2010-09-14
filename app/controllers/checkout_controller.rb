class CheckoutController < ApplicationController
  require 'uuidtools'
  require 'money'

  ssl_exceptions
  before_filter :store_location, :only => [:checkout]

  def checkout
    if session[:uuid]
      @nameframe = Nameframe.find_by_uuid(session[:uuid])
      @nameframe.without_images = true if @nameframe.flex_address.nil?
      @nameframe.save
      @cost = @nameframe.calculate_cost
    else
      flash[:notice] = "Sorry but your session has expired, please enter your name again"
      redirect_to root_path
    end
  end

  def submit_order
    #First, check the session and the nameframe
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    unless @nameframe
      flash[:notice] = "Sorry but your session has expired, please enter your name again"
      render :json => {:status => :failure, :message => "Sorry but your session has expired, please enter your name again", :redirect_to => root_path }
    end

    #Then, ensure the user exists
    @user = self.current_user

    if @user.nil? && params[:email_address].blank?
      @email_error = 1
      @email_address = params[:email_address] || ""
      render :json => {:status => :failure, :message => "Please provide an email address" ,:errors => ["Please provide an email address"], :error_type => "email_blank"}
      return
    end

    #Then try to check the purchase

    @billing_address = Billing.new(
                      :user => @user,
                      :first_name => params[:billing_first_name],
                      :last_name => params[:billing_last_name],
                      :address_1 => params[:billing_address_1],
                      :address_2 => params[:billing_address_2],
                      :country => params[:billing_country_hidden],
                      :city => params[:billing_city],
                      :zip => params[:billing_zip],
                      :state => params[:billing_state_hidden])
    @shipping_address = Shipping.new(
                      :user => @user,
                      :first_name => params[:shipping_first_name],
                      :last_name => params[:shipping_last_name],
                      :address_1 => params[:shipping_address_1],
                      :address_2 => params[:shipping_address_2],
                      :country => params[:shipping_country_hidden],
                      :city => params[:shipping_city],
                      :zip => params[:shipping_zip],
                      :state => params[:shipping_state_hidden]
                      )

    #Then try to check the data in the models
    unless @billing_address.save && @shipping_address.save
      unless @billing_address.errors.empty?
        render :json => {:status => :failure, :message => "Your transaction was not successfully processed. Please review your checkout billing information and try again.", :errors => @billing_address.errors, :error_type => "billing_address"}
        return
      end
      unless @shipping_address.errors.empty?
        render :json => {:status => :failure, :message => "Your transaction was not successfully processed. Please review your checkout shipping information and try again.", :errors => @shipping_address.errors, :error_type => "shipping_address" }
        return
      end
      return
    end

    nameframe_cost = @nameframe.calculate_cost

    shipping_cost =  Checkout.shipping_cost(@shipping_address.country, @shipping_address.state, params[:shipping_cost])

    tax = Checkout.tax_cost(@shipping_address.country, @shipping_address.state, nameframe_cost)

    total = nameframe_cost + shipping_cost + tax

    @free_nameframe_code = FreeNameframeCode.find_by_code(params[:how_did_you_hear_about_us])

    if @free_nameframe_code
      discount = @free_nameframe_code.take_discount
      total = total - total * discount / 100 if discount
    else
      @marketing_answer = MarketingAnswer.new(:description => params[:how_did_you_hear_about_us]) unless params[:how_did_you_hear_about_us].blank?
    end

    unless @user.nil?
      @nameframe.user = @user
      @nameframe.save
    end

    @checkout = Checkout.new(
      :nameframe => @nameframe,
      :email => params[:email_address],
      :total => total,
      :shipping_cost => shipping_cost,
      :nameframe_cost =>nameframe_cost,
      :shipping_type => params[:shipping_cost],
      :tax => tax,
      :gift_to => params[:gift_to],
      :gift_from => params[:gift_from],
      :gift_message => params[:gift_message],
      :cc_number => params[:credit_card_number],
      :cvv => params[:cvv],
      :expiration_year => params[:expiration_year],
      :expiration_month => params[:expiration_month],
      :shipping => @shipping_address,
      :billing => @billing_address,
      :user => @user,
      :card_type => params[:card_type],
      :status=>Checkout::STATE_NEW,
      :archived=>0
    )

    response = @checkout.purchase
    if response.success?
      flash[:notice] = "Success"

      @checkout.authorization = response.authorization
      @checkout.transaction = response.params[:transaction_id]

      @checkout.save
      begin
        Notifier.deliver_order_confirm_email(@checkout)
        Notifier.deliver_order_notification_email(@checkout)
      rescue Exception => e
        RAILS_DEFAULT_LOGGER.info("********************************************************************")
        RAILS_DEFAULT_LOGGER.info("Exception : #{e}")
        RAILS_DEFAULT_LOGGER.info("********************************************************************")
        @billing_address.destroy
        @shipping_address.destroy
        @marketing_answer.destroy if @marketing_answer
        @checkout.destroy
        render :json => {:status => :failure, :message => "There were problems with the service, please contact a System Administrator or try again later."}
        return
      end

      unless session[:photo_customizations].blank?
        # First, we delete all the customizations previously saved
        @nameframe.uploaded_images.each{|photo| photo.photo_customizations.delete_all }
        # Then loop over the saved customizations and saved them
        @nameframe.set_images_customizations(session[:photo_customizations])
      end

      @nameframe.save

      session[:order_completed] = @checkout.order_number
      render :json => {:status => :success, :message => response.message.to_s, :redirect_to => order_completed_path}
      return
    else
      @billing_address.destroy
      @shipping_address.destroy
      @free_nameframe_code.return_code if @free_nameframe_code
      @marketing_answer.destroy if @marketing_answer
      @checkout_transaction = CheckoutTransaction.new(
#        :checkout => @checkout, # We need to check if we will save this information in another table
        :cc_number => @checkout.cc_number,
        :remote_ip => request.remote_ip,
        :message => response.message,
        :cvv_code => response.cvv_result["code"],
        :cvv_message => response.cvv_result["message"],
        :avs_result_code => response.avs_result["code"],
        :avs_postal_match => response.avs_result["postal_match"],
        :avs_street_match => response.avs_result["street_match"],
        :avs_message => response.avs_result["message"],
        :response_code => response.params["response_code"],
        :response_reason_code => response.params["response_reason_code"],
        :success => response.success?,
        :authorization => response.authorization,
        :transaction => response.params["transaction_id"]
      )

      @checkout_transaction.save

      render :json => {:status => :failure, :message => "Your transaction was not successfully processed. Please review your checkout information and try again.", :errors => [ response.message.to_s, response.avs_result["message"], response.cvv_result["message"] ], :error_type =>"credit_card"}
      return
    end
  end

  def validate_cc_number
    creditcard = ActiveMerchant::Billing::CreditCard.new(
      :number => params[:cc],
      :verification_value => params[:cvv],
      :month => params[:exp_month].to_i,
      :year => params[:exp_year].to_i,
      :first_name => params[:b_first_name],
      :last_name => params[:b_last_name],
      :type => params[:cc_type]
    )
    if creditcard.valid?
      render :json => {:status => :success}
    else
      render :json => {:status => :failure, :creditcard_errors => creditcard.errors}
    end
  end

  # Will recieve short names => shipping_country : USA, shipping_state: AL {for alabama} and shipping_city
  def calculate_costs
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    nameframe_cost = @nameframe.calculate_cost
    shipping_cost = Checkout.shipping_cost(params[:shipping_country], params[:shipping_state], params[:shipping_type])

    tax_cost = Checkout.tax_cost(params[:shipping_country], params[:shipping_state], nameframe_cost)

    shipping_cost = 0 if shipping_cost.nil?
    tax_cost = 0 if tax_cost.nil?

    code = FreeNameframeCode.find_by_code(params[:how_did_you_hear_about_us])

    logger.debug "----------->: #{params[:shipping_state]}"
    logger.debug "----------->: #{params[:shipping_country]}"  
    logger.debug "----------->: #{params[:how_did_you_hear_about_us]}" 

    discount = (code && code.discount)? code.discount : 0

    render :json => {
        :nameframe_cost => nameframe_cost,
        :shipping_cost => shipping_cost,
        :tax => tax_cost,
        :total => (nameframe_cost + shipping_cost + tax_cost) * (1 - discount/100)
      }
  end
end

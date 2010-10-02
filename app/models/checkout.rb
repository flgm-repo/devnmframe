class Checkout < ActiveRecord::Base

  belongs_to :user
  belongs_to :shipping, :foreign_key => :shipping_address_id, :class_name => "Shipping"
  belongs_to :billing, :foreign_key => :billing_address_id, :class_name => "Billing"
  belongs_to :nameframe
  has_many :transactions, :class_name => "CheckoutTransaction"

  validate_on_create :validate_card
  STATE_NEW = 1
  STATE_IN_PROGRESS = 2
  STATE_COMPLETED= 3
  STATE_CANCELED = 4

  SPECIAL_SHIPPING = "special"
  GROUND_SHIPPING = "ground"
  TWO_DAYS_SHIPPING = "2_days"
  ONE_DAY_SHIPPING = "1_day"

  attr_accessor :cc_number, :cvv, :expiration_year, :expiration_month

  named_scope :orders_in_progress, :conditions => {:status => Checkout::STATE_IN_PROGRESS}
  named_scope :shipped, :conditions => {:status => Checkout::STATE_COMPLETED}
  named_scope :canceled, :conditions => {:status => Checkout::STATE_CANCELED}
  named_scope :newest, :conditions => {:status => Checkout::STATE_NEW},:order=>"created_at DESC", :limit=>7
  named_scope :shipped, :conditions => {:status => Checkout::STATE_COMPLETED},:order=>"created_at DESC", :limit=>7
  named_scope :archived,  lambda{|arch| {:conditions => {:archived => arch}}}
  named_scope :show_asc, :order => "status ASC"
  named_scope :order_by, lambda{|order| {:order => order }}
  named_scope :filter_by,lambda{|filter| { :conditions => {:status =>filter } }}

  def shipping_method
    case self.shipping_type
      when SPECIAL_SHIPPING
        "Ground"
      when GROUND_SHIPPING
        "Ground"
      when TWO_DAYS_SHIPPING
        "2 Days Delivery"
      when ONE_DAY_SHIPPING
        "Next Day Delivery"
    end
  end


  def status_name
    case self.status
    when STATE_NEW
        "New"
    when STATE_IN_PROGRESS
        "In Progress"
    when STATE_COMPLETED
        "Completed"
    when STATE_CANCELED
        "Canceled"
    else
        "Undefined"
    end
  end
  
  def user_name
    name = "No Profile Name"
    name = self.user.name unless self.user.blank? || self.user.name.blank?
    name
  end

  def self.shipping_cost(shipping_country, shipping_state, shipping_type)
    if shipping_country == "CANADA" || shipping_state == "HI" || shipping_state == "AK"
      19.95
    elsif shipping_type == GROUND_SHIPPING
      6.95
    elsif shipping_type == TWO_DAYS_SHIPPING
      12.95
    elsif shipping_type == ONE_DAY_SHIPPING
      29.95
    else
      nil
    end
  end

  def self.tax_cost(shipping_country, shipping_state, cost)
    if (shipping_country == "USA" && shipping_state == "PA")
      (0.06 * cost).round(2)
    else
      0
    end
  end

  def total_in_cents
    self.total * 100
  end

  def purchase
    amount_to_charge = total_in_cents
    
    gateway = ActiveMerchant::Billing::Base.gateway(:authorize_net).new(
      :login => Settings.authorize_net_login,
      :password => Settings.authorize_net_password,
      :test => Settings.authorize_net_test   # switch :test => false  to switch to production mode
    )

    response = gateway.authorize(amount_to_charge, credit_card, purchase_options) #first authorize

    if response.success?
      gateway.capture(amount_to_charge, response.authorization) # If Authorized.net authorizes, do the capure
                                                                # gateway.purchase = gateway.authorize + gateway.capture
      response
    else
      response
    end
  end
  
  def self.filter(filter_by, order_by, archived)
    unless filter_by==0
      orders = self.archived(archived).order_by(order_by).filter_by(filter_by)
    else
      orders = self.archived(archived).order_by(order_by)
    end
  end

  def order_number
    self.id.to_s.rjust(8, "0")
  end

  private

  def purchase_options
    {
      :billing_address => {
        :name     => "#{billing.first_name} #{billing.last_name}",
        :address1 => billing.address_1,
        :city     => billing.city,
        :state    => billing.state,
        :country  => billing.country,
        :zip      => billing.zip
      }
    }
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end

  def credit_card
    @creditcard = ActiveMerchant::Billing::CreditCard.new(
      :number => cc_number,
      :verification_value => cvv,
      :month => expiration_month.to_i,
      :year => expiration_year.to_i,
      :first_name => billing.first_name,
      :last_name => billing.last_name,
      :type => card_type
    )
  end
end


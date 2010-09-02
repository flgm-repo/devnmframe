class FreeNameframeCode < ActiveRecord::Base
  named_scope :enabled, :conditions => ["enabled IS TRUE"]
  named_scope :by_code, lambda { |code| { :conditions => ["code = ?", code] } }
  validates_uniqueness_of :code
  validates_presence_of :code, :discount, :users_quantity, :start_date, :end_date
  validates_numericality_of :discount, :users_quantity
  validates_numericality_of :discount, :less_than_or_equal_to => 100, :greater_than_or_equal_to => 0
  validates_date :start_date, :format => "yyyy-mm-dd"
  validates_date :end_date, :format => "yyyy-mm-dd", :on_or_after => :start_date
  before_validation :check_special_data

  attr_accessor :indefinite_users

  def check_special_data
    if self.indefinite_users == "1"
      self.users_quantity = -1
    end
  end

  def allowed_users
    (self.users_quantity && self.users_quantity < 0)? "Indefinite" : self.users_quantity
  end

  def indefinite_users?
    (self.users_quantity && self.users_quantity < 0)? true : false
  end

  def take_discount
    #Check if the date is correct
    time_ok = (Time.now).between? self.start_date, self.end_date + 1.day
    #Check if the user count is correct
    users_quantity_ok = self.users_quantity && self.users_quantity > 0
    #Give the discount or false
    if (time_ok and users_quantity_ok)
      self.users_quantity -= 1
      self.save
      self.discount
    else
      false
    end
  end

  def return_code
    self.users_quantity += 1
    self.save
  end
end

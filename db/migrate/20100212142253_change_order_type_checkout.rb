class ChangeOrderTypeCheckout < ActiveRecord::Migration
  def self.up
    change_column :checkouts, :order_number, :string
  end

  def self.down
  end
end

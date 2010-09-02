class AddShippingCostToCheckout < ActiveRecord::Migration
  def self.up
    add_column :checkouts, :shipping_cost, :float
  end

  def self.down
    remove_column :checkouts, :shipping_cost
  end
end

class AddShippingTypeToCheckout < ActiveRecord::Migration
  def self.up
    add_column :checkouts, :shipping_type, :string
  end

  def self.down
    remove_column :checkouts, :shipping_type
  end
end

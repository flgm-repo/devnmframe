class AddZipToShippingAndBillingAddr < ActiveRecord::Migration
  def self.up
    add_column :addresses, :zip, :string
  end

  def self.down
    add_column :addresses, :zip
  end
end

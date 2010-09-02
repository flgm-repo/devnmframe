class AddIpToCheckoutTransaction < ActiveRecord::Migration
  def self.up
    add_column :checkout_transactions, :remote_ip, :string
  end

  def self.down
    remove_column :checkout_transactions, :remote_ip
  end
end

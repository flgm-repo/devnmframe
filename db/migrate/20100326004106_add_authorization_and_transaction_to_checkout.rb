class AddAuthorizationAndTransactionToCheckout < ActiveRecord::Migration
  def self.up
    add_column :checkouts, :authorization, :string
    add_column :checkouts, :transaction, :string
  end

  def self.down
    remove_column :checkouts, :transaction
    remove_column :checkouts, :authorization
  end
end

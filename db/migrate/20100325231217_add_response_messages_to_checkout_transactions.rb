class AddResponseMessagesToCheckoutTransactions < ActiveRecord::Migration
  def self.up
    add_column :checkout_transactions, :cvv_code, :string
    add_column :checkout_transactions, :cvv_message, :string
    add_column :checkout_transactions, :avs_result_code, :string
    add_column :checkout_transactions, :avs_postal_match, :string
    add_column :checkout_transactions, :avs_street_match, :string
    add_column :checkout_transactions, :avs_message, :string
    add_column :checkout_transactions, :response_code, :string
    add_column :checkout_transactions, :response_reason_code, :string
    add_column :checkout_transactions, :success, :boolean
    add_column :checkout_transactions, :authorization, :string
    add_column :checkout_transactions, :transaction, :string
  end

  def self.down
    remove_column :checkout_transactions, :transaction
    remove_column :checkout_transactions, :authorization
    remove_column :checkout_transactions, :success
    remove_column :checkout_transactions, :response_reason_code
    remove_column :checkout_transactions, :response_code
    remove_column :checkout_transactions, :avs_message
    remove_column :checkout_transactions, :avs_street_match
    remove_column :checkout_transactions, :avs_postal_match
    remove_column :checkout_transactions, :avs_result_code
    remove_column :checkout_transactions, :cvv_message
    remove_column :checkout_transactions, :cvv_code
  end
end

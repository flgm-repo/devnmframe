class RemoveCcProps < ActiveRecord::Migration
  def self.up
    remove_column :checkouts, :credit_card
    remove_column :checkouts, :cvv
    remove_column :checkouts, :expiration_year
    remove_column :checkouts, :expiration_month
  end

  def self.down
    add_column :checkouts, :expiration_month, :integer
    add_column :checkouts, :expiration_year, :integer
    add_column :checkouts, :cvv, :string
    add_column :checkouts, :credit_card, :string
  end
end

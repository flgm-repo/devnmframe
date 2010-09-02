class AddEmailToCheckout < ActiveRecord::Migration
  def self.up
    add_column :checkouts, :email, :string
  end

  def self.down
    remove_column :checkouts, :email
  end
end

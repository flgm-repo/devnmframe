class AddStatusToCheckout < ActiveRecord::Migration
  def self.up
    add_column :checkouts, :status, :integer
  end

  def self.down
    remove_column :checkouts, :status
  end
end


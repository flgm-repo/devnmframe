class AddNameframeCostToCheckout < ActiveRecord::Migration
  def self.up
    add_column :checkouts, :nameframe_cost, :float
  end

  def self.down
    remove_column :checkouts, :nameframe_cost
  end
end

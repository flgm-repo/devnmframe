class RemoveColumnsFromAssets < ActiveRecord::Migration
  def self.up
    remove_column :assets, :asset_type
    remove_column :assets, :price
  end

  def self.down
    add_column :assets, :asset_type, :string
    add_column :assets, :price, :float
  end
end

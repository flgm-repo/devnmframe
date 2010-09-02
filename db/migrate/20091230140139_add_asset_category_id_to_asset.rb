class AddAssetCategoryIdToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :asset_category_id, :int
  end

  def self.down
    remove_column :assets, :asset_category_id
  end
end

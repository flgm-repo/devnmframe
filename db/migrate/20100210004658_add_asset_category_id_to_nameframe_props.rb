class AddAssetCategoryIdToNameframeProps < ActiveRecord::Migration
  def self.up
    add_column :nameframe_props, :asset_category_id, :integer
  end

  def self.down
    remove_column :nameframe_props, :asset_category_id
  end
end

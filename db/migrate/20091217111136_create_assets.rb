class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :uuid, :limit => 36
      t.string :image_location
      t.string :display_name
      t.string :asset_type
      t.float :price
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end

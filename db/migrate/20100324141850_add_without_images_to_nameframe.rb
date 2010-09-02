class AddWithoutImagesToNameframe < ActiveRecord::Migration
  def self.up
    add_column :nameframes, :without_images, :boolean
  end

  def self.down
    remove_column :nameframes, :without_photos
  end
end

class AddImagePathsToFrames < ActiveRecord::Migration
  def self.up
    rename_column (:frames, :image, :small_image)
    rename_column (:frames, :image_large, :large_image)
    add_column :frames, :medium_image, :string
  end

  def self.down
    remove_column :frames, :medium_image
    rename_column :frames, :large_image, :image_large
    rename_column :frames, :small_image, :image
  end
end

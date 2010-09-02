class AddStretchVarsToPhotoCustomizations < ActiveRecord::Migration
  def self.up
    add_column :photo_customizations, :is_mask_stretchable, :boolean
    add_column :photo_customizations, :stretched_image_height, :float
    add_column :photo_customizations, :stretched_image_width, :float
  end

  def self.down
    remove_column :photo_customizations, :stretched_image_width
    remove_column :photo_customizations, :stretched_image_height
    remove_column :photo_customizations, :is_mask_stretchable
  end
end

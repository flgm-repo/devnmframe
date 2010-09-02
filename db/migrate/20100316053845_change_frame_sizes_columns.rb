class ChangeFrameSizesColumns < ActiveRecord::Migration
  def self.up
    remove_column :frames, :medium_image
    remove_column :frames, :large_image
    rename_column :frames, :small_image, :file_name
  end

  def self.down
    rename_column :frames, :file_name, :small_image
    add_column :frames, :large_image, :string
    add_column :frames, :medium_image, :string
  end
end

class AddCoreImageToMatt < ActiveRecord::Migration
  def self.up
    add_column :matts, :core_image, :string
  end

  def self.down
    remove_column :matts, :core_image
  end
end

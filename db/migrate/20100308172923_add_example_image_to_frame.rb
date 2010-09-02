class AddExampleImageToFrame < ActiveRecord::Migration
  def self.up
    add_column :frames, :example_image, :string
  end

  def self.down
    remove_column :frames, :example_image
  end
end

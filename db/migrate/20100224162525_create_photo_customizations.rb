class CreatePhotoCustomizations < ActiveRecord::Migration
  def self.up
    create_table :photo_customizations do |t|
      t.integer :x, :y
      t.float :rotation, :width, :height
      t.references :photo
      t.timestamps
    end 
  end

  def self.down
    drop_table :photo_customizations
  end
end

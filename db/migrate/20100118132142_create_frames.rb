class CreateFrames < ActiveRecord::Migration
  def self.up
    create_table :frames do |t|
      t.string :uuid, :limit => 36
      t.string :name
      t.string :image
      t.string :image_large
      t.integer :top
      t.integer :bottom
      t.integer :left
      t.integer :right
      t.integer :top_large
      t.integer :bottom_large
      t.integer :left_large
      t.integer :right_large
      t.timestamps
      
    end
  end

  def self.down
    drop_table :frames
  end
end

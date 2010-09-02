class AddLetterPositionToPhotoCustomizations < ActiveRecord::Migration
  def self.up
    add_column :photo_customizations, :letter_position, :integer
  end

  def self.down
    remove_column :photo_customizations, :letter_position
  end
end

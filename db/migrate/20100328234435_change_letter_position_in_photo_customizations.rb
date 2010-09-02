class ChangeLetterPositionInPhotoCustomizations < ActiveRecord::Migration
  def self.up
    change_column :photo_customizations, :letter_position, :string
  end

  def self.down
    change_column :photo_customizations, :letter_position, :integer
  end
end

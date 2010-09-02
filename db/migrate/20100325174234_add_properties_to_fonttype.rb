class AddPropertiesToFonttype < ActiveRecord::Migration
  def self.up
    add_column :font_types, :kerning, :float
    add_column :font_types, :letter_width, :float
    add_column :font_types, :height_factor, :decimal, :precision => 10, :scale => 9
  end

  def self.down
    remove_column :font_types, :kerning
    remove_column :font_types, :letter_width
    remove_column :font_types, :height_factor
  end
end


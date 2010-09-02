class CreateFontTypes < ActiveRecord::Migration
  def self.up
    create_table :font_types do |t|
      t.string :name, :file_name
      t.timestamps
    end
  end

  def self.down
    drop_table :font_types
  end
end

class AddFontIdAndTextToNameframe < ActiveRecord::Migration
  def self.up
    add_column :nameframes, :font_id, :integer
    add_column :nameframes, :selected_text, :string
  end

  def self.down
    remove_column :nameframes, :selected_text
    remove_column :nameframes, :font_id
  end
end

class AddImageNameToNameframe < ActiveRecord::Migration
  def self.up
    add_column :nameframes, :image_name, :string
  end

  def self.down
    remove_column :nameframes, :image_name
  end
end

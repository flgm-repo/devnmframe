class AddFlexAddressToNameframe < ActiveRecord::Migration
  def self.up
    add_column :nameframes, :flex_address, :string
  end

  def self.down
    remove_column :nameframes, :flex_address
  end
end

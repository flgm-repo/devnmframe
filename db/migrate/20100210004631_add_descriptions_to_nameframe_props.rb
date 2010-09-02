class AddDescriptionsToNameframeProps < ActiveRecord::Migration
  def self.up
    add_column :nameframe_props, :description, :string
    add_column :nameframe_props, :flag, :integer
  end

  def self.down
    remove_column :nameframe_props, :flag
    remove_column :nameframe_props, :description
  end
end

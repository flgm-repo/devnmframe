class AddCostToNameframeProps < ActiveRecord::Migration
  def self.up
    add_column :nameframe_props, :cost, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :nameframe_props, :cost
  end
end

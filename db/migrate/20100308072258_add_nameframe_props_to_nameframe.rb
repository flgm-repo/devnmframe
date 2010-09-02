class AddNameframePropsToNameframe < ActiveRecord::Migration
  def self.up
    add_column :nameframes, :frame_id, :integer
    add_column :nameframes, :top_matt_id, :integer
    add_column :nameframes, :bottom_matt_id, :integer
    add_column :nameframes, :top_left_ornament_id, :integer
    add_column :nameframes, :top_right_ornament_id, :integer
    add_column :nameframes, :bottom_left_ornament_id, :integer
    add_column :nameframes, :bottom_right_ornament_id, :integer
  end

  def self.down
    remove_column :nameframes, :frame_id
    remove_column :nameframes, :top_matt_id
    remove_column :nameframes, :bottom_matt_id
    remove_column :nameframes, :top_left_ornament_id
    remove_column :nameframes, :top_right_ornament_id
    remove_column :nameframes, :bottom_left_ornament_id
    remove_column :nameframes, :bottom_right_ornament_id
  end
end

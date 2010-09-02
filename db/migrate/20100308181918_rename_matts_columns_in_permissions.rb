class RenameMattsColumnsInPermissions < ActiveRecord::Migration
  def self.up
    rename_column :frame_matt_permissions, :top_matt_id, :bottom_matt_id_2
    rename_column :frame_matt_permissions, :bottom_matt_id, :top_matt_id
    rename_column :frame_matt_permissions, :bottom_matt_id_2, :bottom_matt_id
  end

  def self.down
    rename_column :frame_matt_permissions, :bottom_matt_id_2, :top_matt_id
    rename_column :frame_matt_permissions, :top_matt_id, :bottom_matt_id
    rename_column :frame_matt_permissions, :bottom_matt_id, :bottom_matt_id_2
  end
end

class CreateFrameMattPermissions < ActiveRecord::Migration
  def self.up
    create_table :frame_matt_permissions do |t|
      t.integer :frame_id
      t.integer :top_matt_id
      t.integer :bottom_matt_id
      t.boolean :allowed
      
      t.timestamps
    end
  end

  def self.down
    drop_table :frame_matt_permissions
  end
end

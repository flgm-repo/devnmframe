class CreateNameframeProps < ActiveRecord::Migration
  def self.up
    create_table :nameframe_props do |t|
      t.integer :asset_id
      t.integer :nameframe_id

      t.timestamps
    end
  end

  def self.down
    drop_table :nameframe_props
  end
end

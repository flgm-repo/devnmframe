class CreateOrnaments < ActiveRecord::Migration
  def self.up
    create_table :ornaments do |t|
      t.string :name, :displayed_name
      t.string :file_name
      t.timestamps
    end
  end

  def self.down
    drop_table :ornaments
  end
end

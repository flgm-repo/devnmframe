class CreateMatts < ActiveRecord::Migration
  def self.up
    create_table :matts do |t|
      t.string :uuid
      t.string :image
      t.string :name
      t.string :code
      
      t.timestamps
    end
  end

  def self.down
    drop_table :matts
  end
end

class CreateNameframes < ActiveRecord::Migration
  def self.up
    create_table :nameframes do |t|
      t.string :uuid
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :nameframes
  end
end

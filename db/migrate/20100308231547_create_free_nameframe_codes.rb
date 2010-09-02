class CreateFreeNameframeCodes < ActiveRecord::Migration
  def self.up
    create_table :free_nameframe_codes do |t|
      t.string :code
      t.boolean :enabled
      t.timestamps
    end
  end

  def self.down
    drop_table :free_nameframe_codes
  end
end

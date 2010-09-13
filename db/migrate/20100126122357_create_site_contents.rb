class CreateSiteContents < ActiveRecord::Migration
  def self.up
    create_table :site_contents do |t|
      t.string :section
      t.string :content
      t.timestamps
    end
  end

  def self.down
    drop_table :site_contents
  end
end

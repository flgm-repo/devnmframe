class SiteContentsReferenceSection < ActiveRecord::Migration
  def self.up
    rename_column :site_contents, :section, :section_id
    change_table :site_contents do |t|
      t.change :section_id, :integer
    end
  end

  def self.down
    change_table :site_contents do |t|
      t.change :section_id, :string
    end
    rename_column :site_contents, :section_id, :section
  end
end

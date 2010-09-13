class ModifyDatatypeOfContentToSiteContents < ActiveRecord::Migration
  def self.up
   change_column :site_contents, :content, :text
  end

  def self.down
   change_column :site_contents, :content, :varchar
  end
end

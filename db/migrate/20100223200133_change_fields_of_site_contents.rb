class ChangeFieldsOfSiteContents < ActiveRecord::Migration
  def self.up
    add_column :site_contents, :owner, :string
    add_column :site_contents, :link, :string
    add_column :site_contents, :filename, :string
    add_column :site_contents, :content_type, :string
    add_column :site_contents, :thumbnail, :string 
    add_column :site_contents, :size, :integer
    add_column :site_contents, :width, :integer
    add_column :site_contents, :height, :integer
  end

  def self.down
    remove_column :site_contents, :owner
    remove_column :site_contents, :link
    remove_column :site_contents, :filename
    remove_column :site_contents, :content_type
    remove_column :site_contents, :thumbnail
    remove_column :site_contents, :size
    remove_column :site_contents, :width
    remove_column :site_contents, :height
  end
end

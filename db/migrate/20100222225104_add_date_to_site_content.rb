class AddDateToSiteContent < ActiveRecord::Migration
  def self.up
    add_column :site_contents, :publication_date, :date
  end

  def self.down
    remove_column :site_contents, :publication_date
  end
end

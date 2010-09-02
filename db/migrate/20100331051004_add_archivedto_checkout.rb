class AddArchivedtoCheckout < ActiveRecord::Migration
  def self.up
    add_column :checkouts, :archived, :int
  end

  def self.down
    remove_column :checkouts, :archived
  end
end

class RemoveEnabledFromFreeNameframeCodes < ActiveRecord::Migration
  def self.up
    remove_column :free_nameframe_codes, :enabled
  end

  def self.down
    add_column :free_nameframe_codes, :enabled, :boolean
  end
end

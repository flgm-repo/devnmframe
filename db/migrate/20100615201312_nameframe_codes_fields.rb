class NameframeCodesFields < ActiveRecord::Migration
  def self.up
    add_column :free_nameframe_codes, :discount, :float
    add_column :free_nameframe_codes, :users_quantity, :integer
    add_column :free_nameframe_codes, :start_date, :date
    add_column :free_nameframe_codes, :end_date, :date
  end

  def self.down
    remove_column :free_nameframe_codes, :end_date
    remove_column :free_nameframe_codes, :start_date
    remove_column :free_nameframe_codes, :users_quantity
    remove_column :free_nameframe_codes, :discount
  end
end

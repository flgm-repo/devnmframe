class AddUserIdColumnToNameframes < ActiveRecord::Migration
  def self.up
    add_column :nameframes, :user_id, :integer
  end

  def self.down
    remove_column :nameframes, :user_id
  end
end

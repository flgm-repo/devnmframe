class AddTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :token, :string
    
    # Create the token for existing users
    User.all.each do |u|
      u.save
    end
  end

  def self.down
    remove_column :users, :token
  end
end

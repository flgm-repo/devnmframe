class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :country
      t.float :shipping_price
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end

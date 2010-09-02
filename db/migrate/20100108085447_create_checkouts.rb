class CreateCheckouts < ActiveRecord::Migration
  def self.up
    create_table :checkouts do |t|
      t.string :gift_to
      t.string :gift_from
      t.string :gift_message
      t.string :credit_card
      t.string :cvv
      t.integer :expiration_year
      t.integer :expiration_month
      t.integer :shipping_address_id
      t.integer :billing_address_id
      t.integer :user_id
      t.integer :nameframe_id
      t.integer :order_number
      t.float :total
      t.float :tax
      t.string :card_type
      t.timestamps
    end
  end

  def self.down
    drop_table :checkouts
  end
end

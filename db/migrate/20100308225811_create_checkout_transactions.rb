class CreateCheckoutTransactions < ActiveRecord::Migration
  def self.up
    create_table :checkout_transactions do |t|
      t.references :checkout
      t.string :cc_number
      t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :checkout_transactions
  end
end

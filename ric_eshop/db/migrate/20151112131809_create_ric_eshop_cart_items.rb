class CreateRicEshopCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|

      # Timestamps
      t.timestamps null: true

      # Link to session
      t.integer :session_id

      # Product
      t.integer :product_id
      t.string :product_name
      t.integer :product_price
      t.string :product_currency
      t.integer :amount

    end
  end
end

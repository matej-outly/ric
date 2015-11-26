class CreateRicEshopCartItems < ActiveRecord::Migration
	def change
		create_table :cart_items do |t|

			# Timestamps
			t.timestamps null: true

			# Link to session
			t.integer :session_id

			# Amount
			t.integer :amount

			# Product
			t.integer :product_id
			t.string :product_name
			t.integer :product_price
			t.string :product_currency
			
			# Subproducts
			t.string :sub_product_ids
			t.string :sub_product_names
			t.string :sub_product_prices
			t.string :sub_product_currencies
			
		end
	end
end

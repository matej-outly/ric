class CreateRicEshopOrderItems < ActiveRecord::Migration
	def change
		create_table :order_items do |t|

			# Timestamps
			t.timestamps null: true

			# Link to order
			t.integer :order_id, index: true

			# Amount
			t.integer :amount

			# Product
			t.integer :product_id, index: true
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

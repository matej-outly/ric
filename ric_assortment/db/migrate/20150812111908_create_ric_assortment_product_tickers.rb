class CreateRicAssortmentProductTickers < ActiveRecord::Migration
	def change
		create_table :product_tickers do |t|

			t.timestamps null: true
			
			# Identification
			t.string :name
			t.string :key
		end
		create_table :product_tickers_products, id: false do |t|

			t.timestamps null: true

			# Bind
			t.integer :product_id
			t.integer :product_ticker_id

		end
	end
end

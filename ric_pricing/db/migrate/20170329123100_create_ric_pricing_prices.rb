class CreateRicPricingPrices < ActiveRecord::Migration
	def change
		create_table :prices do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position, index: true
			
			# Association
			t.integer :price_list_id, index: true

			# Description
			t.string :description

			# Price
			t.float :price
			t.string :currency
			t.string :operator

			# Amount
			t.string :amount

		end
	end
end

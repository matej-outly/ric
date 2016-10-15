class CreateRicAssortmentProductTeasers < ActiveRecord::Migration
	def change
		create_table :product_teasers do |t|

			t.timestamps null: true
			
			# Identification
			t.string :name
			t.string :key, index: true

		end
		create_table :product_teasers_products, id: false do |t|

			t.timestamps null: true

			# Relations
			t.integer :product_id, index: true
			t.integer :product_teaser_id, index: true

		end
	end
end

class CreateRicAssortmentProductVariants < ActiveRecord::Migration
	def change
		create_table :product_variants do |t|

			# Timestamps
			t.timestamps null: true

			# POsition
			t.integer :position

			# Identification
			t.integer :product_id
			t.string :name

			# Behaviour
			t.boolean :required
			t.string :operator
			
		end
		create_table :product_variants_products, id: false do |t|

			t.timestamps null: true

			# Bind
			t.integer :product_id
			t.integer :product_variant_id

		end
	end
end

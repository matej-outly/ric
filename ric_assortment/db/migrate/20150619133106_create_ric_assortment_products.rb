class CreateRicAssortmentProducts < ActiveRecord::Migration
	def change
		create_table :products do |t|

			t.timestamps null: true

			# Ordering
			t.integer :position, index: true

			# Identification
			t.string :name
			t.string :catalogue_number
			t.string :ean

			# Content
			t.text :perex
			t.text :content

			# Standard attributes
			#t.integer :height, index: true
			#t.integer :width, index: true
			#t.integer :depth, index: true
			#t.integer :weight, index: true
			# ... to be defined according to application

			# Other (dynamically defined) attributes
			t.hstore :other_attributes

			# Price
			t.integer :price
			t.string :currency

			# Product category
			t.integer :default_product_category_id, index: true

			# Product manufacturer
			t.integer :product_manufacturer_id, index: true

			# Meta
			t.string :keywords
			t.string :description
			
		end
		add_index :products, :other_attributes, using: :gin
	end
end

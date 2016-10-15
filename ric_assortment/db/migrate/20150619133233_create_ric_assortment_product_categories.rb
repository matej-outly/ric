class CreateRicAssortmentProductCategories < ActiveRecord::Migration
	def change
		create_table :product_categories do |t|

			t.timestamps null: true

			# Hierarchical ordering
			t.integer :parent_id, null: true, index: true
			t.integer :lft, null: false, index: true
			t.integer :rgt, null: false, index: true
			t.integer :depth, null: false, default: 0

			# Name
			t.string :name

			# Content
			t.text :perex
			t.text :content

			# Default attributes dynamically defined for contaned products
			t.string :default_attributes

		end
		create_table :product_categories_products, id: false do |t|

			t.timestamps null: true

			# Relations
			t.integer :product_id, index: true
			t.integer :product_category_id, index: true

		end
	end
end

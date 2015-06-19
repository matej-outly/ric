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
		end
	end
end

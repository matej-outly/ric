class CreateRicWebsitePages < ActiveRecord::Migration
	def change
		create_table :pages do |t|

			t.timestamps null: true

			# Hierarchical ordering
			t.integer :parent_id, null: true, index: true
			t.integer :lft, null: false, index: true
			t.integer :rgt, null: false, index: true
			t.integer :depth, null: false, default: 0

			# Name
			t.string :name
			
			# URL
			t.string :nature
			t.integer :model_id
			t.string :model_type
			t.string :url

		end
	end
end

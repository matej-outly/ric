class CreateRicWebsitePages < ActiveRecord::Migration
	def change
		create_table :pages do |t|

			t.timestamps null: true

			# Hierarchical ordering
			t.integer :parent_id, null: true, index: true
			t.integer :lft, null: false, index: true
			t.integer :rgt, null: false, index: true
			t.integer :depth, null: false, default: 0

			# Title
			t.string :title
			
			# URL
			t.string :nature
			t.integer :model_id
			t.string :model_type
			t.string :url

			# Meta
			t.string :meta_title
			t.string :meta_description

			# Design
			t.attachment :background
			t.string :layout

		end
	end
end

class CreateRicGalleryGalleryDirectories < ActiveRecord::Migration
	def change
		create_table :gallery_directories do |t|

			t.timestamps null: true

			# Hierarchical ordering
			t.integer :parent_id, null: true, index: true
			t.integer :lft, null: false, index: true
			t.integer :rgt, null: false, index: true
			t.integer :depth, null: false, default: 0

			# Data
			t.string :name
			t.text :description
			t.attachment :image

		end
	end
end

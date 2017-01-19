class CreateRicWebsiteNodes < ActiveRecord::Migration
	def change
		create_table :nodes do |t|
			t.timestamps null: true
			
			# Hierarchical ordering
			t.integer :parent_id, null: true, index: true
			t.integer :lft, null: false, index: true
			t.integer :rgt, null: false, index: true
			t.integer :depth, null: false, default: 0
			
			# Identification
			t.string :ref, index: true
			t.string :name
			
			# Structure
			t.integer :structure_id, index: true
			t.boolean :show_in_navigation, index: true
			t.boolean :is_navigable, index: true
			t.boolean :has_pictures
			t.boolean :has_attachments
		end
	end
end

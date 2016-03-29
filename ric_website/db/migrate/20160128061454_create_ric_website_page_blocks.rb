class CreateRicWebsitePageBlocks < ActiveRecord::Migration
	def change
		create_table :page_blocks do |t|

			# Timestamps
			t.timestamps null: true

			# Position
			t.integer :position

			# Key
			t.string :key
	
			# Relation to page
			t.integer :page_id

			# Subject
			t.integer :subject_id
			t.string :subject_type

		end
	end
end

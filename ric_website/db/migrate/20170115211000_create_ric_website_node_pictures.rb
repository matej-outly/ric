class CreateRicWebsiteNodePictures < ActiveRecord::Migration
	def change
		create_table :node_pictures do |t|
			t.timestamps null: true

			# Relation
			t.integer :node_id

			# Picture
			t.attachment :picture

			# Description
			t.string :description

			# Picture dimensions
			t.integer :width
			t.integer :height

		end
	end
end

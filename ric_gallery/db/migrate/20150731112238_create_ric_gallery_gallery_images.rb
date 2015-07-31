class CreateRicGalleryGalleryImages < ActiveRecord::Migration
	def change
		create_table :gallery_images do |t|

			t.timestamps null: true

			# Position
			t.integer :position

			# Directory
			t.integer :gallery_directory_id

			# Data
			t.attachment :image
			t.string :title

		end
	end
end

class CreateRicGalleryGalleryPictures < ActiveRecord::Migration
	def change
		create_table :gallery_pictures do |t|

			t.timestamps null: true

			# Position
			t.integer :position

			# Directory
			t.integer :gallery_directory_id

			# Data
			t.attachment :picture
			t.string :title

		end
	end
end

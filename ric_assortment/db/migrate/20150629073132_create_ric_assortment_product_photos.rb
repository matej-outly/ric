class CreateRicAssortmentProductPhotos < ActiveRecord::Migration
	def change
		create_table :product_photos do |t|

			t.timestamps null: true

			# Position
			t.integer :position

			# Product
			t.integer :product_id
			
			# Title
			t.string :title

			# Picture
			t.attachment :picture
			t.integer :picture_crop_x
			t.integer :picture_crop_y
			t.integer :picture_crop_w
			t.integer :picture_crop_h

		end
	end
end

class CreateRicAssortmentProductPictures < ActiveRecord::Migration
	def change
		create_table :product_pictures do |t|

			t.timestamps null: true

			# Position
			t.integer :position, index: true

			# Product
			t.integer :product_id, index: true
			
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

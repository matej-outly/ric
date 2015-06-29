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

			# Image
			t.attachment :image

		end
	end
end

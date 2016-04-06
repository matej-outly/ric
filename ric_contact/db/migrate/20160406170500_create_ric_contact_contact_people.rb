class CreateRicContactContactPeople < ActiveRecord::Migration
	def change
		create_table :contact_people do |t|

			t.timestamps null: true

			# Position
			t.integer :position

			# Name
			t.string :name_title
			t.string :name_firstname
			t.string :name_lastname
			
			# Role
			t.string :role

			# Localized role
			#t.string :role_cs
			#t.string :role_en

			# Contact
			t.string :phone
			t.string :email
		
			# Photo
			t.attachment :photo
			#t.integer :photo_crop_x # Only if croppable
			#t.integer :photo_crop_y # Only if croppable
			#t.integer :photo_crop_w # Only if croppable
			#t.integer :photo_crop_h # Only if croppable
			
		end
	end
end
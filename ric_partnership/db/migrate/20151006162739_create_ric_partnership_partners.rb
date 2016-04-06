class CreateRicPartnershipPartners < ActiveRecord::Migration
	def change
		create_table :partners do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position
			
			# Name
			t.string :name

			# Localized name
			#t.string :name_cs
			#t.string :name_en

			# URL
			t.string :url

			# Image
			t.attachment :logo
		end
	end
end

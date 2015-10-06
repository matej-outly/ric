class CreateRicPartnershipPartners < ActiveRecord::Migration
	def change
		create_table :partners do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position
			
			# Name
			t.string :name

			# URL
			t.string :url

			# Image
			t.attachment :logo
		end
	end
end

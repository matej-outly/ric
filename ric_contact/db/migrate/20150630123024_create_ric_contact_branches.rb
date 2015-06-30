class CreateRicContactBranches < ActiveRecord::Migration
	def change
		create_table :branches do |t|

			t.timestamps null: true

			# Identification
			t.string :name
			
			# Contact
			t.string :address
			t.string :url

			# Location
			t.string :latitude
			t.string :longitude

		end
	end
end

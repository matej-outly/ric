class CreateRicAssortmentProductManufacturers < ActiveRecord::Migration
	def change
		create_table :product_manufacturers do |t|

			t.timestamps null: true
			
			# Identification
			t.string :name
			t.string :url

			# Logo
			t.attachment :logo
			
		end
	end
end

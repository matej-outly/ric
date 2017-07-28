class CreateRicPricingPriceLists < ActiveRecord::Migration
	def change
		create_table :price_lists do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position, index: true
			
			# Name
			t.string :name

			# Subject
			t.integer :subject_id, index: true
			t.string :subject_type, index: true

		end
	end
end

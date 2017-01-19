class CreateRicWebsiteFields < ActiveRecord::Migration
	def change
		create_table :fields do |t|
			t.timestamps null: true
			
			# Ordering
			t.integer :position, index: true

			# Structure
			t.integer :structure_id, index: true
			
			# Identification
			t.string :ref, index: true
			t.string :name
			t.boolean :include_in_url

			# Kind
			t.string :kind
			t.integer :enum_id, index: true

		end
	end
end

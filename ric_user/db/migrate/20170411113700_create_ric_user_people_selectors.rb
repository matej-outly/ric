class CreateRicUserPeopleSelectors < ActiveRecord::Migration
	def change
		create_table :people_selectors do |t|
			
			# Timestamps
			t.timestamps null: true

			# Selector definition
			#t.string :selector
			t.string :key
			t.string :params
			
			# Human readable title
			t.string :title

			# Subject
			t.integer :subject_id, index: true
			t.string :subject_type, index: true

		end

	end
end

class CreateRicSettingsSettings < ActiveRecord::Migration
	def change
		create_table :settings do |t|

			t.timestamps null: true

			# Ordering
			t.integer :position, index: true
			
			# Identification
			t.string :ref, index: true
			t.string :value
			t.string :kind
			
			# Category
			t.string :category
		end
	end
end

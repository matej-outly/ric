class CreateRicServiceServices < ActiveRecord::Migration
	def change
		create_table :services do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position, index: true
			
			# Name
			t.string :name

			# Description
			t.text :description
			
			# Icon
			t.string :icon

		end
	end
end

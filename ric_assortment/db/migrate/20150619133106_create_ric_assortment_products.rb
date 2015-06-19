class CreateRicAssortmentProducts < ActiveRecord::Migration
	def change
		create_table :products do |t|

			t.timestamps null: true

			# Ordering
			t.integer :position

			# Name
			t.string :name
		end
	end
end

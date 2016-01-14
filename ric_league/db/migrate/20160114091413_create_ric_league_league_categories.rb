class CreateRicLeagueLeagueCategories < ActiveRecord::Migration
	def change
		create_table :league_categories do |t|

			# Timestamps
			t.timestamps null: true

			# Position
			t.integer :position

			# Name
			t.string :name
		end
	end
end

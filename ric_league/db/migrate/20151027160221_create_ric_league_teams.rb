class CreateRicLeagueTeams < ActiveRecord::Migration
	def change
		create_table :teams do |t|

			# Timestamps
			t.timestamps null: true
			
			# Position
			t.integer :position
			
			# Identification
			t.string :key
			t.string :name

			# Description
			t.text :description
			t.attachment :logo
			t.attachment :photo

		end
	end
end
class CreateRicSeasonSeasons < ActiveRecord::Migration
	def change
		create_table :seasons do |t|

			t.timestamps null: true
			
			# Name
			t.string :name

			# Dates
			t.date :from
			t.date :to

			# Current flag
			t.boolean :current

		end
	end
end

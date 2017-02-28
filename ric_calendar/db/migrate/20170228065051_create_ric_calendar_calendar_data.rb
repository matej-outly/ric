class CreateRicCalendarCalendarData < ActiveRecord::Migration
	def change
		create_table :calendar_data do |t|

			# Timestamps
			t.timestamps null: true

			# Title
			t.string :title

			# Description
			t.text :description
		end
	end
end

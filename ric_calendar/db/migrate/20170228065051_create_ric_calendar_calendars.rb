class CreateRicCalendarCalendars < ActiveRecord::Migration
	def change
		create_table :calendars do |t|

			# Timestamps
			t.timestamps null: true

			# Name
			t.string :name

			# Kind defining resource and event spec in config
			t.string :kind

			# Resource spec
			t.string :resource_type, index: true
			t.integer :resource_id, index: true

			# Access level spec
			t.boolean :is_public

			# *****************************************************************
			# Color
			# *****************************************************************

			t.string :color

			# *****************************************************************
			# Validity
			# *****************************************************************

			t.date :valid_from, index: true
			t.date :valid_to, index: true

		end
	end
end

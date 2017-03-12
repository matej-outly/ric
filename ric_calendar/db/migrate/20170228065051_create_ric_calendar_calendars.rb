class CreateRicCalendarCalendars < ActiveRecord::Migration
	def change
		create_table :calendars do |t|

			# Timestamps
			t.timestamps null: true

			# Title
			t.string :name

			# Color
			t.string :color

			# Kind defining resource and event spec in config
			t.string :kind

			# Resource spec
			t.string :resource_type, index: true
			t.integer :resource_id, index: true
			#t.string :resource_to_events_attr
			
			# Event spec
			#t.string :event_type, index: true
			#t.string :event_to_resource_attr

		end
	end
end

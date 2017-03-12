class CreateRicCalendarEvents < ActiveRecord::Migration
	def change
		create_table :events do |t|

			# Timestamps
			t.timestamps null: true

			# *************************************************************************
			# Schedulable
			# *************************************************************************

			# Event start
			t.date :date_from, index: true
			t.time :time_from

			# Event end
			t.date :date_to, index: true
			t.time :time_to

			# All day
			t.boolean :all_day

			# *************************************************************************
			# Recurring
			# *************************************************************************

			# Recurrence rule
			t.text :recurrence_rule

			# Is it generated?
			t.integer :source_event_id

			# *************************************************************************
			# Validity
			# *************************************************************************

			# Validity TODO
			t.date :valid_from, index: true
			t.date :valid_to, index: true

			# *************************************************************************
			# Calendar
			# *************************************************************************
			
			t.integer :calendar_id
			t.string :color
			
			# *************************************************************************
			# Event data (can be customized)
			# *************************************************************************
			
			t.string :name
			t.text :description

		end
	end
end

class CreateRicCalendarCalendarEvents < ActiveRecord::Migration
	def change
		create_table :calendar_events do |t|

			# Timestamps
			t.timestamps null: true

			# *************************************************************************
			# Event time
			# *************************************************************************

			# Event start
			t.date :start_date, index: true
			t.time :start_time, null: true

			# Event end
			t.date :end_date, index: true
			t.time :end_time, null: true

			# All day
			t.boolean :all_day

			# t.boolean :is_recurred, default: false
			t.text :recurrence_rule, null: true

			# Is it generated?
			t.integer :source_event_id, null: true


			# *************************************************************************
			# Event data
			# *************************************************************************
			t.string :title
			t.text :description

		end
	end
end

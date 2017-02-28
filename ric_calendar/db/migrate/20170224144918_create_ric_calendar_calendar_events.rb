class CreateRicCalendarCalendarEvents < ActiveRecord::Migration
	def change
		create_table :calendar_events do |t|

			# Timestamps
			t.timestamps null: true

			# Event start
			t.date :start_date, index: true
			t.time :start_time, null: true

			# Event end
			t.date :end_date, index: true
			t.time :end_time, null: true

			# Is all day (then start_time and end_time should be null)
			t.boolean :all_day

			# Is generated from CalendarEventTemplate
			t.integer :calendar_event_template_id

			# Is modified (has different time than defined by CalendarEventTemplate generator)
			t.boolean :is_modified

			# Event data (such as title etc.)
			t.integer :calendar_data_id, null: false

		end
	end
end

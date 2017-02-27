class CreateRicCalendarCalendarEvents < ActiveRecord::Migration
	def change
		create_table :calendar_events do |t|
			t.timestamps null: true

			t.date :start_date
			t.time :start_time

			t.date :end_date
			t.time :end_time

			t.boolean :all_day

			t.integer :calendar_event_template_id

			t.string :title
			t.text :description

		end
	end
end

class CreateRicCalendarCalendarEventTemplates < ActiveRecord::Migration
	def change
		create_table :calendar_event_templates do |t|

			# Timestamps
			t.timestamps null: true

			# Event template start date
			t.date :start_date, index: true, null: true

			# Event template end date
			t.date :end_date, index: true, null: true

			# Serialized Ice Cube rules
			t.text :ice_cube_rule

			# Event data (such as title etc.)
			t.integer :calendar_data_id, null: false

		end
	end
end

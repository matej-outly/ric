class AddCalendarIdToCalendarEvents < ActiveRecord::Migration
	def change
		add_column :calendar_events, :calendar_id, :integer
	end
end

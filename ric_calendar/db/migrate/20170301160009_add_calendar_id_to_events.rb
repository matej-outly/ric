class AddCalendarIdToEvents < ActiveRecord::Migration
	def change
		add_column :events, :calendar_id, :integer
	end
end

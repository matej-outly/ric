class AddShowActionToRicCalendarCalendar < ActiveRecord::Migration
	def change

		# Path to controller for showing event
		add_column :calendars, :show_action, :string, null: true

	end
end

# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Create event modifier migration
# *
# * Author: Matěj Outlý
# * Date  : 25. 11. 2015
# *
# *****************************************************************************

class CreateRicReservationEventModifiers < ActiveRecord::Migration
	def change
		create_table :event_modifiers do |t|
			t.timestamps null: true

			# Bind to events
			t.integer :event_id

			# Schedule
			t.date :schedule_date

			# Modifications
			t.boolean :tmp_canceled
			t.datetime :tmp_from
			t.datetime :tmp_to

		end
	end
end
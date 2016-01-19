# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Create event migration
# *
# * Author: Matěj Outlý
# * Date  : 25. 11. 2015
# *
# *****************************************************************************

class CreateRicReservationEvents < ActiveRecord::Migration
	def change
		create_table :events do |t|
			t.timestamps null: true

			# Single table inheritance
			t.string :type
			
			# Bind to resources
			t.integer :resource_id

			# Identification
			t.string :name
			t.string :color

			# Schedule
			t.datetime :from
			t.datetime :to
			t.string :period

			# Validity
			t.date :valid_from
			t.date :valid_to

			# Capacity
			t.integer :capacity

			# Time window
			t.time :time_window_soon
			t.time :time_window_deadline

			# Limit number of reservations by single owner
			t.integer :owner_reservation_limit

		end
	end
end
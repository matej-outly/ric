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
			t.integer :time_window_soon
			t.integer :time_window_deadline

		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Create resource migration
# *
# * Author: Matěj Outlý
# * Date  : 25. 11. 2015
# *
# *****************************************************************************

class CreateRicReservationResources < ActiveRecord::Migration
	def change
		create_table :resources do |t|
			t.timestamps null: true

			# Position
			t.integer :position

			# Identification
			t.string :name

			# Time window
			t.datetime :time_window_open
			t.datetime :time_window_soon
			t.datetime :time_window_deadline

			# Limit number of reservations by single owner
			t.integer :owner_reservation_limit

			# Opening hours
			t.integer :opening_hours_min
			t.integer :opening_hours_max

			# Validity
			t.date :valid_from
			t.date :valid_to

			# Period
			t.string :period

		end
	end
end
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
			t.integer :position, index: true

			# Identification
			t.string :name

			# Time window
			t.datetime :time_window_open
			t.datetime :time_window_soon
			t.datetime :time_window_deadline

			# Time fixed
			#t.datetime :time_fixed_open
			#t.datetime :time_fixed_deadline
			#t.datetime :time_fixed_soon
			#t.datetime :time_fixed_already_closed

			# Limit number of reservations by single owner
			t.integer :owner_reservation_limit

			# Opening hours
			t.integer :opening_hours_min
			t.integer :opening_hours_max

			# Validity
			t.date :valid_from, index: true
			t.date :valid_to, index: true

			# Period
			t.string :period

		end
	end
end
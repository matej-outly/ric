# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Create reservation migration
# *
# * Author: Matěj Outlý
# * Date  : 25. 11. 2015
# *
# *****************************************************************************

class CreateRicReservationReservations < ActiveRecord::Migration
	def change
		create_table :reservations do |t|
			t.timestamps null: true

			# Kind
			t.string :kind

			# Resource reservation
			t.integer :resource_id
			t.datetime :schedule_from
			t.datetime :schedule_to

			# Event reservation
			t.integer :event_id
			t.date :schedule_date
			t.integer :size
			t.boolean :below_line

			# Owner
			t.integer :owner_id
			t.string :owner_name

			# Subject
			t.integer :subject_id
			t.string :subject_type

			# Color
			t.string :color
			
		end
	end
end
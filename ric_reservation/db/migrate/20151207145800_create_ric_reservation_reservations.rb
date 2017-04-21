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
			t.integer :resource_id, index: true
			t.string :resource_type, index: true
			t.datetime :schedule_from
			t.datetime :schedule_to

			# Event reservation
			t.integer :event_id, index: true
			t.string :event_type, index: true
			t.date :schedule_date
			t.boolean :below_line

			# Size - disable some of the following if not needed in application
			t.integer :size_integer
			t.time :size_time

			# Owner
			t.integer :owner_id, index: true
			t.string :owner_type, index: true
			t.string :owner_name

			# Subject
			t.integer :subject_id, index: true
			t.string :subject_type, index: true

			# Identification
			t.string :name
			
		end
	end
end
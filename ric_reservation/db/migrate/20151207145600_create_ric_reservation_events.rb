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
	
	# Depends on events table defined in RicCalendar

	# Resource
	add_column :events, :resource_id, :integer
	add_index  :events, :resource_id
	
	# Capacity - choose one of the columns representing correct capacity type
	#add_column :events, :capacity_integer, :integer
	#add_column :events, :capacity_time, :time

	# Time window - choose if reservation policy should be time_window
	add_column :events, :time_window_open, :datetime
	add_column :events, :time_window_soon, :datetime
	add_column :events, :time_window_deadline, :datetime

	# Time fixed - choose if reservation policy should be time_fixed
	#add_column :events, :time_fixed_open, :datetime
	#add_column :events, :time_fixed_deadline, :datetime
	#add_column :events, :time_fixed_soon, :datetime
	#add_column :events, :time_fixed_already_closed, :datetime

	# Limit number of reservations by single owner
	add_column :events, :owner_reservation_limit, :integer

end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document folder model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module CalendarEventTemplate extend ActiveSupport::Concern

				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					belongs_to :calendar_data, class_name: RicCalendar.calendar_data_model.to_s
					accepts_nested_attributes_for :calendar_data

					# TODO After destroy

					# *************************************************************************
					# Ice Cube rules
					# *************************************************************************
					after_initialize :deserialize_ice_cube_rules
					before_save :serialize_ice_cube_rules

					attr_accessor :recurrence

				end

				module ClassMethods

					# *************************************************************************
					# Columns
					# *************************************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:start_date,
							:start_time,
							:end_date,
							:end_time,
							:calendar_data_id,

							:ice_cube_rule,
							:recurrence, # Weekly, monthly
							:interval, # Every month, every two weeks, ...



						]
					end

					# *************************************************************************
					# Queries
					# *************************************************************************

					#
					# Return all events between given dates
					#
					def schedule(start_date, end_date)
						where("start_date >= ? AND end_date <= ?", start_date, end_date)
					end

				end


				# *************************************************************************
				# Ice Cube
				# *************************************************************************

				def deserialize_ice_cube_rules
					if !self.ice_cube_rule.blank?
						@recurrence = IceCube::Schedule.from_hash(self.ice_cube_rule)
					else
						@recurrence = IceCube::Schedule.new
					end
				end

				def serialize_ice_cube_rules
					self.ice_cube_rule = @recurrence.to_hash
				end


			end
		end
	end
end
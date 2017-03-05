# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module CalendarEvent extend ActiveSupport::Concern

				module ClassMethods

					# *************************************************************************
					# Columns
					# *************************************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:title,
							:description,

							:start_date,
							:start_time,
							:end_date,
							:end_time,
							:all_day,

							:source_event_id,
							:recurrence_rule,
						]

					end


				end

				# *************************************************************************
				# Conversions
				# *************************************************************************

				def into_fullcalendar(fullcalendar_event)
					fullcalendar_event[:title] = self.title
				end

			end

		end
	end
end
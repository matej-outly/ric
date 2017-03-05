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

				included do

					validates :title, :start_date, :start_time, :end_date, :end_time, presence: true
					validates :calendar_id, presence: true, if: :has_calendar_id?

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
							:title,
							:description,

							:calendar_id,

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
				# Methods
				# *************************************************************************

				#
				# Check, if instance has optional attribute "calendar_id"
				#
				def has_calendar_id?
					has_attribute?("calendar_id")
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
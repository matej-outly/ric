# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Event extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :calendar

					# *********************************************************
					# Validators
					# *********************************************************

					validates :title, :start_date, :start_time, :end_date, :end_time, presence: true
					validates :calendar_id, presence: true

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							# Event data
							:title,
							:description,

							# Schedulable
							:start_date,
							:start_time,
							:end_date,
							:end_time,
							:all_day,

							# Recurring
							:source_event_id,
							:recurrence_rule,

							# Calendar
							:calendar_id,
						]
					end


				end

				# *************************************************************
				# Conversions
				# *************************************************************

				def to_fullcalendar(fullevent)
					fullevent[:title] = self.title
				end

			end
		end
	end
end
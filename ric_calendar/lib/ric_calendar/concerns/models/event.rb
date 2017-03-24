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

					validates :name, :calendar_id, presence: true

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						result = []
						result = result.concat(self.permitted_columns_for_schedulable)
						result = result.concat(self.permitted_columns_for_recurring)
						result = result.concat(self.permitted_columns_for_validity)
						result = result.concat(self.permitted_columns_for_colored)
						result = result.concat([

							# Event data
							:name,
							:description,

							# Calendar
							:calendar_id,
						])
						return result
					end

				end

				# *************************************************************
				# Conversions
				# *************************************************************

				def to_fullcalendar(fullevent)
					fullevent[:title] = self.name
				end

			end
		end
	end
end
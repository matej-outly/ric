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
			module Recurring extend ActiveSupport::Concern

				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					belongs_to :source_event, class_name: self.class.name

					before_save do
						# Recurring-select gem sets "null" string instead of real null
						if self.recurrence_rule == "null"
							self.recurrence_rule = nil
						end
					end
				end

				#
				# Return all occurrences of this event between given dates by Ice Cube
				# recurrence rule
				#
				def occurrences(start_date, end_date)
					rule = RecurringSelect.dirty_hash_to_rule(self.recurrence_rule)

					schedule = IceCube::Schedule.new(self.start_date)
					schedule.add_recurrence_rule(rule.until(self.end_date))
					return schedule.occurrences_between(start_date, end_date, spans: true)
				end

			end

		end
	end
end
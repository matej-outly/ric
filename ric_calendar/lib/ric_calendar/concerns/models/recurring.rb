# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Recurring
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Recurring extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :source_event, class_name: self.class.name

					before_validation do
						# Recurring-select gem sets "null" string instead of real null
						if self.recurrence_rule == "null"
							self.recurrence_rule = nil
						end
					end
				end

				module ClassMethods
					
					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns_for_recurring
						[
							:source_event_id,
							:recurrence_rule,
						]
					end

				end

				#
				# Return all occurrences of this event between given dates by Ice Cube
				# recurrence rule
				#
				def occurrences(date_from, date_to)
					rule = RecurringSelect.dirty_hash_to_rule(self.recurrence_rule)
					schedule = IceCube::Schedule.new(self.date_from)
					schedule.add_recurrence_rule(rule.until(self.date_to))
					return schedule.occurrences_between(date_from, date_to, spans: true)
				end

			end

		end
	end
end
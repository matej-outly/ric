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
					return self.schedule.occurrences_between(date_from, date_to, spans: true)
				end

				#
				# Get human readable recurrence rule
				#
				def recurrence_rule_formatted
					return self.schedule.to_s
				end

				#
				# Get IceCube Schedule object
				#
				def schedule
					if @schedule.nil?
						# Start time should be composed from valid_from field,
						# which gives date. And from time_from field, which gives
						# time.
						start_time = self.datetime_from(self.valid_from)

						# Create IceCube scheduler object
						@schedule = IceCube::Schedule.new(start_time)

						# Set duration of event
						@schedule.duration = (self.datetime_to.to_time - self.datetime_from.to_time).round

						# Deserialize saved recurrence rule
						rule = RecurringSelect.dirty_hash_to_rule(self.recurrence_rule)

						# Rule is valid until valid_to date
						rule = rule.until(self.valid_to)

						# Pass date time into rule
						@schedule.add_recurrence_rule(rule)
					end

					return @schedule
				end

			end

		end
	end
end
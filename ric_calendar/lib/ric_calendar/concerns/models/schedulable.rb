# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Schedulable
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Schedulable extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in
				# the module's context.
				#
				included do

					# *********************************************************
					# Validators
					# *********************************************************

					validates :date_from, :time_from, :date_to, :time_to, :valid_from, :valid_to, presence: true
					validate :validate_from_to_consistency

					# *********************************************************
					# Callbacks
					# *********************************************************

					before_validation :set_date_to_before_validation
					before_validation :set_valid_from_to_before_validation

				end

				module ClassMethods

					# *********************************************************
					# Queries
					# *********************************************************

					#
					# Return all events between given dates
					#
					def between(date_from, date_to)
						where("(#{self.table_name}.valid_from <= :valid_to) AND (:valid_from <= #{self.table_name}.valid_to)", valid_from: date_from, valid_to: date_to)
					end

					#
					# Return all occurences of events in dates
					#
					def schedule(date_from, date_to)
						scheduled_events = []

						between(date_from, date_to).each do |event|

							scheduled_event_base = {
								event: event,
								time_from: event.time_from,
								time_to: event.time_to,
								all_day: event.all_day,
								is_recurring: false,
							}

							if !event.is_recurring?
								# Regular event
								scheduled_event_base[:date_from] = event.date_from
								scheduled_event_base[:date_to] = event.date_to
								scheduled_events << scheduled_event_base

							else
								# Recurring event
								event.occurrences(date_from, date_to).each do |occurence|
									scheduled_event = scheduled_event_base.clone
									scheduled_event[:date_from] = occurence.start_time.to_date
									scheduled_event[:date_to] = occurence.end_time.to_date
									scheduled_event[:is_recurring] = true
									scheduled_event[:recurrence_template_id] = event.id
									scheduled_events << scheduled_event
								end

							end
						end

						return scheduled_events
					end

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns_for_schedulable
						[
							:date_from,
							:time_from,
							:date_to,
							:time_to,
							:all_day,
							:valid_from,
							:valid_to,
						]
					end

				end

				# *************************************************************
				# Recurring
				# *************************************************************

				def is_recurring?
					self.has_attribute?(:recurrence_rule) && !self.recurrence_rule.nil?
				end

				# *************************************************************
				# Date and time
				# *************************************************************

				#
				# Make DateTime object from (given) Date and Time objects
				#
				def datetime_from(base_date = self.date_from)
					if self.time_from
						DateTime.compose(base_date, self.time_from)
					else
						base_date.to_datetime
					end
				end

				#
				# Make DateTime object from (given) Date and Time objects
				#
				def datetime_to(base_date = self.date_to)
					if self.time_to
						DateTime.compose(base_date, self.time_to)
					else
						base_date.to_datetime
					end
				end

				# *************************************************************
				# Formatted time
				# *************************************************************

				def time_formatted
					result = ""

					# Format date
					if !self.is_recurring?
						result += self.date_from.strftime("%-d. %-m. %Y")
					else
						result += self.recurrence_rule_formatted
					end

					# Format time
					if !self.all_day
						result += " " + self.time_from.strftime("%k:%M") + " - " + self.time_to.strftime("%k:%M")
					else
						result += ", " + I18n.t("activerecord.attributes.ric_calendar/event.all_day").downcase_first
					end

					return result
				end

				# *************************************************************
				# Conversions
				# *************************************************************

				#
				# This method must be implemented in model:
				#

				# def to_fullcalendar(fullevent)
				#	fullevent[:title] = self.name
				# end

			protected

				#
				# "From" must be before "to" (causality)
				#
				def validate_from_to_consistency
					# Causality on valid_from & valid_to
					if self.valid_from > self.valid_to
						errors.add(:valid_to, I18n.t("activerecord.errors.models.#{self.class.model_name.i18n_key}.attributes.valid_to.before_from"))
					end

					if self.date_from.nil? || self.time_from.nil? || self.date_to.nil? || self.time_to.nil?
						return
					end

					# Causality
					if self.datetime_from >= self.datetime_to
						errors.add(:date_to, I18n.t("activerecord.errors.models.#{self.class.model_name.i18n_key}.attributes.date_to.before_from"))
						errors.add(:time_to, I18n.t("activerecord.errors.models.#{self.class.model_name.i18n_key}.attributes.time_to.before_from"))
					end
				end

				#
				# Set date to correctly if not defined
				#
				def set_date_to_before_validation
					if self.date_to.blank?
						self.date_to = self.date_from
					end
				end

				#
				# Set valid from / valid to correctly
				#
				def set_valid_from_to_before_validation
					if !is_recurring?
						self.valid_from = self.date_from
						self.valid_to = self.date_to
					else
						self.valid_from = self.date_from
						# self.valid_to should be set by user
					end
				end

			end

		end
	end
end
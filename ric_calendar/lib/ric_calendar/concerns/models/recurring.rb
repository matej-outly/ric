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

					belongs_to :source_event, class_name: name
					has_many :source_events, class_name: name, foreign_key: "source_event_id", dependent: :nullify

					# Recurrence exclude is set of excluded dates
					serialize :recurrence_exclude, Set

					# *********************************************************
					# Validation & updates
					# *********************************************************

					before_validation :set_recurrence_rule_to_real_nil
					validate :validate_update_action

					before_update :update_row

					# *********************************************************
					# Helper attribute for editing
					# *********************************************************

					attr_accessor :update_action
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
							:recurrence_exclude,
							:update_action,
							:scheduled_date_from,
						]
					end

				end

				# *********************************************************
				# Virtual attributes
				# *********************************************************

				def scheduled_date_from
					@scheduled_date_from
				end

				def scheduled_date_from=(str)
					@scheduled_date_from = !str.blank? ? Date.parse(str) : nil
				end

				# *********************************************************
				# Scheduling
				# *********************************************************

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

						# Add rule to the schedule
						@schedule.add_recurrence_rule(rule)

						# Add exception dates
						self.recurrence_exclude.each do |exclude_date|
							# Each exception must have same time as time_from (IceCube requirement)
							exception_time = Time.new(
								exclude_date.year, exclude_date.month, exclude_date.day,
								self.time_from.hour, self.time_from.min, self.time_from.sec
							)

							@schedule.add_exception_time(exception_time)
						end
					end

					return @schedule
				end

				#
				# Extract this event from recurrenting row of events
				#
				def extract_from_recurrent(scheduled_date_from = self.scheduled_date_from)
					# Get original instance of this event and duplicate it
					recurrent_event = self.class.find(self.id)
					if recurrent_event.nil?
						return false
					end

					recurrent_event = recurrent_event.dup

					# Extract given occurrence from recurrenting event
					recurrent_event.recurrence_exclude << scheduled_date_from
					unless recurrent_event.save
						return false
					end

					# Remove recurrence rule
					self.recurrence_rule = nil
					self.recurrence_exclude = nil
					self.source_event_id = recurrent_event.id

					# Set dates to split date
					if !self.date_from_changed? && !self.date_to_changed?
						self.date_from = scheduled_date_from
						self.date_to = self.date_from
					end

					return recurrent_event
				end

				#
				# Split event in given date
				#
				def split_recurrent(scheduled_date_from = self.scheduled_date_from)
					# Get original instance of this event and duplicate it
					past_event = self.class.find(self.id)
					if past_event.nil?
						return false
					end

					past_event = past_event.dup

					# Stretch past event
					past_event.valid_to = scheduled_date_from - 1.day
					past_event.recurrence_exclude.delete_if { |date| date > past_event.valid_to }

					unless past_event.save
						return false
					end

					# Update
					self.valid_from = scheduled_date_from
					self.recurrence_exclude.delete_if { |date| date < self.valid_from }

					return past_event
				end


			protected
				#
				# Fix recurrence select return value to be nil
				#
				def set_recurrence_rule_to_real_nil
					# Recurring-select gem sets "null" string instead of real null
					if self.recurrence_rule == "null"
						self.recurrence_rule = nil
					end
				end

				#
				# Validate update actions and neccessary attributes
				#
				def validate_update_action
					if self.update_action.in?(["only_this", "all_future"]) && self.scheduled_date_from.nil?
						# In these cases we need scheduled_date_from to be filled
						errors.add(:scheduled_date_from, I18n.t("activerecord.errors.models.#{self.class.model_name.i18n_key}.attributes.scheduled_date_from.blank"))
					end
				end

				# *********************************************************
				# Updates
				# *********************************************************

				#
				# Update only this scheduled event
				#
				def update_row
					if !self.is_recurring? || !self.update_action.in?(["only_this", "all_future"])
						return true
					end

					if self.update_action == "only_this"
						# Remove recurrence rules from this instance
						return extract_from_recurrent

					elsif self.update_action == "all_future"
						# Split event
						return split_recurrent
					end
				end




			end
		end
	end
end
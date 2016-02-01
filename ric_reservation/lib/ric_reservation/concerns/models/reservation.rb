# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Reservation
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module Reservation extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# One-to-many relation with owners
					#
					belongs_to :owner, class_name: RicReservation.owner_model.to_s

					#
					# One-to-many relation with subjects
					#
					belongs_to :subject, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present (always)
					#
					validates_presence_of :kind, :schedule_from, :schedule_to
					
					#
					# From / to times must be consistent
					#
					validate :validate_from_to_consistency

					# *********************************************************
					# Kind
					# *********************************************************

					#
					# Kind
					#
					enum_column :kind, ["event", "resource"]

					# *********************************************************
					# Color
					# *********************************************************

					#
					# Period
					#
					enum_column :color, ["yellow", "turquoise", "blue", "pink", "violet", "orange", "red", "green"], default: "yellow"

					# *************************************************************
					# Time
					# *************************************************************

					#
					# Virtual attributes
					#
					attr_writer :time_from
					attr_writer :time_to

					#
					# Correct from/to must be set before save
					#
					before_validation :set_from_to_before_validation

					#
					# Copy validation errors
					#
					after_validation :copy_from_to_errors_after_validation

				end

				module ClassMethods

					# *********************************************************
					# Schedule
					# *********************************************************

					#
					# Scope for reservarions in some schedule
					#
					def schedule(date_from, date_to = nil)
						date_to = date_from + 1.day if date_to.nil?
						where(":date_from <= schedule_date AND schedule_date < :date_to", date_from: date_from, date_to: date_to)
					end
					
				end

				# *************************************************************
				# Kind
				# *************************************************************

				#
				# Is kind event?
				#
				def kind_event?
					self.kind == "event"
				end

				#
				# Is kind resource?
				#
				def kind_resource?
					self.kind == "resource"
				end

				# *************************************************************
				# Time
				# *************************************************************

				def time_from
					if self.schedule_from
						return self.schedule_from
					else
						return @time_from
					end
				end

				def time_to
					if self.schedule_to
						return self.schedule_to
					else
						return @time_to
					end
				end

				#
				# Human readable time
				#
				def formatted_time
					return self.schedule_from.strftime("%-d. %-m. %Y %k:%M") + " - " + self.schedule_to.strftime("%k:%M")
				end

				# *************************************************************
				# State
				# *************************************************************

				#
				# Get state according to current date and time
				#
				def state
					
					if @state.nil?
						now = Time.current
						
						# Break points
						if self.kind_event?
							time_window_deadline = self.event.time_window_deadline
							time_window_soon = self.event.time_window_soon
						else # if self.kind_resource?
							time_window_deadline = self.resource.time_window_deadline
							time_window_soon = self.resource.time_window_soon
						end
						if time_window_deadline
							deadline = self.schedule_from - time_window_deadline.days_since_new_year.days - time_window_deadline.seconds_since_midnight.seconds
						else
							deadline = self.schedule_from
						end
						if time_window_soon
							soon = deadline - time_window_soon.days_since_new_year.days - time_window_soon.seconds_since_midnight.seconds
						else
							soon = deadline
						end

						# State recognititon
						if now < soon
							@state = :open
						elsif now < deadline
							@state = :soon
						elsif now < self.schedule_from
							@state = :deadline
						else
							@state = :closed
						end

					end
					return @state
				end

			protected

				# *************************************************************
				# Validators
				# *************************************************************

				#
				# "From" and "to" must be same day, "from" must be before "to" (causality)
				#
				def validate_from_to_consistency

					if self.schedule_from.nil? || self.schedule_to.nil?
						return
					end

					# Same day
					if self.schedule_from.to_date != self.schedule_to.to_date
						errors.add(:schedule_to, I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.attributes.schedule_to.different_day_than_from"))
					end

					# Causality
					if self.schedule_from >= self.schedule_to
						errors.add(:schedule_to, I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.attributes.schedule_to.before_from"))
					end

				end

				# *************************************************************
				# Time
				# *************************************************************

				#
				# Set correct from/to if virtual time_from and time_to attributes set
				#
				def set_from_to_before_validation
					
					# Date
					if self.schedule_date.blank?
						date = nil
					elsif self.schedule_date.is_a?(::String)
						date = Date.parse(self.schedule_date)
					else
						date = self.schedule_date
					end

					# From
					if @time_from.blank?
						time_from = nil
					elsif @time_from.is_a?(::String)
						time_from = DateTime.parse(@time_from)
					else
						time_from = @time_from
					end

					# To
					if @time_to.blank?
						time_to = nil
					elsif @time_to.is_a?(::String)
						time_to = DateTime.parse(@time_to)
					else
						time_to = @time_to
					end

					# Compose
					if !date.nil?
						if !time_from.nil?
							self.schedule_from = DateTime.compose(date, time_from)
						end
						if !time_to.nil?
							self.schedule_to = DateTime.compose(date, time_to)
						end
					end

				end

				#
				# Copy validation errors
				#
				def copy_from_to_errors_after_validation
					errors[:schedule_from].each { |message| errors.add(:time_from, message) }
					errors[:schedule_to].each { |message| errors.add(:time_to, message) }
				end

			end
		end
	end
end
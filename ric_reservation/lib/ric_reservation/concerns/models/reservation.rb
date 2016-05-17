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
					belongs_to :owner, polymorphic: true

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

					#
					# Get reservations owned by some person
					#
					def owned_by(owner)
						if owner.nil?
							all
						else
							where(owner_type: owner.class.to_s, owner_id: owner.id)
						end
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
					result = ""
					resource_period = nil
					if self.kind_event?
						resource_period = self.event.resource.period
					else
						resource_period = self.resource.period
					end
					days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]	
					if resource_period == "week"
						day = days[self.schedule_from.to_datetime.cwday - 1]
						result += I18n.t("date.days.#{day}") + " "
					else
						result += self.schedule_from.strftime("%-d. %-m. %Y ")
					end
					result += self.schedule_from.strftime("%k:%M") + " - " + self.schedule_to.strftime("%k:%M")
					return result
				end

				# *************************************************************
				# State
				# *************************************************************

				#
				# State
				#
				state_column :state, config(:states).map { |state_spec| state_spec[:name] }

				#
				# Get state according to current date and time
				#
				def state
					if @state.nil?
						now = Time.current
						
						# States
						states = config(:states)

						# Break times
						break_times = [self.schedule_from]
						states.reverse_each_with_index do |state_spec, index|
							if index != 0 && index != (states.length - 1) # Do not consider first and last state
								state_name = state_spec[:name]
								if self.kind_event?
									time_window = self.event.send("time_window_#{state_name}")
								else # if self.kind_resource?
									time_window = self.resource.send("time_window_#{state_name}")
								end
								if time_window
									break_times << (break_times.last - time_window.days_since_new_year.days - time_window.seconds_since_midnight.seconds)
								else
									break_times << break_times.last
								end
							end
						end
						
						# State recognititon
						states.each_with_index do |state_spec, index|
							if index < states.length - 1
								if now < break_times[states.length - 2 - index]
									@state = state_spec[:name].to_sym
									@state_behavior = state_spec[:behavior].to_sym
									break
								end
							else # Last fallback state
								@state = state_spec[:name].to_sym
								@state_behavior = state_spec[:behavior].to_sym
								break
							end
						end

					end
					return @state
				end

				#
				# Get state behavior according to current date and time
				#
				def state_behavior
					if @state_behavior.nil?
						self.state
					end
					return @state_behavior
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
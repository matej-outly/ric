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

					belongs_to :owner, polymorphic: true
					belongs_to :subject, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :kind
					
					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, ["event", "resource"]

					# *************************************************************
					# Time
					# *************************************************************

					#
					# Virtual attributes
					#
					#attr_writer :time_from
					#attr_writer :time_to

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
					# Get reservations owned by some person
					#
					def owned_by(owner)
						if owner.nil?
							all
						else
							where(owner_type: owner.class.name, owner_id: owner.id)
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

#				def time_from
#					if self.schedule_from
#						return self.schedule_from
#					else
#						return @time_from
#					end
#				end

#				def time_to
#					if self.schedule_to
#						return self.schedule_to
#					else
#						return @time_to
#					end
#				end

				#
				# Human readable time
				#
				def formatted_time
					result = ""
					#resource_period = nil
					#if self.kind_event?
					#	resource_period = self.event.resource.period
					#else
					#	resource_period = self.resource.period
					#end
					#days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]	
					#if resource_period == "week"
					#	day = days[self.schedule_from.to_datetime.cwday - 1]
					#	result += I18n.t("date.days.#{day}") + " "
					#else
					#	result += self.schedule_from.strftime("%-d. %-m. %Y ")
					#end
					#result += self.schedule_from.strftime("%k:%M") + " - " + self.schedule_to.strftime("%k:%M")
					return result
				end

				# *************************************************************
				# State
				# *************************************************************

				#
				# State
				#
				#state_column :reservation_state, config(:reservation_states).map { |reservation_state_spec| reservation_state_spec[:name] }

				#
				# Get state according to current date and time
				#
				def reservation_state
					if @reservation_state.nil?
						now = Time.current
						
						# States
						reservation_states = config(:reservation_states)

						# Break times
						if config(:reservation_state_policy) == "time_fixed"
							break_times = []
							reservation_states.reverse_each_with_index do |reservation_state_spec, index|
								if index != 0 # Do not consider first state
									reservation_state_name = reservation_state_spec[:name]
									if self.kind_event?
										time_fixed = self.event.send("time_fixed_#{reservation_state_name}")
									else # if self.kind_resource?
										time_fixed = self.resource.send("time_fixed_#{reservation_state_name}")
									end
									if time_fixed
										break_times << time_fixed
									else
										break_times << break_times.last
									end
								end
							end
						else
							break_times = [self.schedule_from]
							reservation_states.reverse_each_with_index do |reservation_state_spec, index|
								if index != 0 && index != (reservation_states.length - 1) # Do not consider first and last state
									reservation_state_name = reservation_state_spec[:name]
									if self.kind_event?
										time_window = self.event.send("time_window_#{reservation_state_name}")
									else # if self.kind_resource?
										time_window = self.resource.send("time_window_#{reservation_state_name}")
									end
									if time_window
										break_times << (break_times.last - time_window.days_since_new_year.days - time_window.seconds_since_midnight.seconds)
									else
										break_times << break_times.last
									end
								end
							end
						end
						
						# State recognititon
						reservation_states.each_with_index do |reservation_state_spec, index|
							if index < reservation_states.length - 1
								if now < break_times[reservation_states.length - 2 - index]
									@reservation_state = reservation_state_spec[:name].to_sym
									@reservation_state_behavior = reservation_state_spec[:behavior].to_sym
									break
								end
							else # Last fallback state
								@reservation_state = reservation_state_spec[:name].to_sym
								@reservation_state_behavior = reservation_state_spec[:behavior].to_sym
								break
							end
						end

					end
					return @reservation_state
				end

				#
				# Get state behavior according to current date and time
				#
				def reservation_state_behavior
					if @reservation_state_behavior.nil?
						self.reservation_state
					end
					return @reservation_state_behavior
				end

			protected

				# *************************************************************
				# Time
				# *************************************************************

				#
				# Set correct from/to if virtual time_from and time_to attributes set
				#
				def set_from_to_before_validation
#					
#					# Date
#					if self.schedule_date.blank?
#						date = nil
#					elsif self.schedule_date.is_a?(::String)
#						date = Date.parse(self.schedule_date)
#					else
#						date = self.schedule_date
#					end#

#					# From
#					if @time_from.blank?
#						time_from = nil
#					elsif @time_from.is_a?(::String)
#						time_from = DateTime.parse(@time_from)
#					else
#						time_from = @time_from
#					end#

#					# To
#					if @time_to.blank?
#						time_to = nil
#					elsif @time_to.is_a?(::String)
#						time_to = DateTime.parse(@time_to)
#					else
#						time_to = @time_to
#					end#

#					# Compose
#					if !date.nil?
#						if !time_from.nil?
#							self.schedule_from = DateTime.compose(date, time_from)
#						end
#						if !time_to.nil?
#							self.schedule_to = DateTime.compose(date, time_to)
#						end
#					end#

				end

				#
				# Copy validation errors
				#
				def copy_from_to_errors_after_validation
					#errors[:schedule_from].each { |message| errors.add(:time_from, message) }
					#errors[:schedule_to].each { |message| errors.add(:time_to, message) }
				end

			end
		end
	end
end
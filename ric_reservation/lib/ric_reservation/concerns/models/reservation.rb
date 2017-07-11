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
				# Schedulable
				# *************************************************************

				def all_day
					false
				end

				# *************************************************************
				# Reservation state
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
							break_times = [self.datetime_from]
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

			end
		end
	end
end
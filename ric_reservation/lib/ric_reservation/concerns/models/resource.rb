# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Resource
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module Resource extend ActiveSupport::Concern

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
					# One-to-many relation with events
					#
					has_many :events, class_name: RicReservation.event_model.to_s, dependent: :destroy

					#
					# One-to-many relation with reservations
					#
					has_many :reservations, -> { where(kind: "resource") }, class_name: RicReservation.reservation_model.to_s, dependent: :destroy
					
					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering

					# *********************************************************
					# Opening hours
					# *********************************************************

					range_column :opening_hours

					# *********************************************************
					# STI
					# *********************************************************

					#
					# Define scope for each available type
					#
					if config(:types)
						config(:types).each do |type|
							scope type.to_snake.pluralize.to_sym, -> { where(type: type) }
						end
					end

					# *********************************************************
					# Time windows
					# *********************************************************

					#
					# Define time windows as duration
					# 
					if config(:states)
						config(:states).each_with_index do |state_spec, index|
							duration_column "time_window_#{state_spec[:name]}".to_sym if index != 0 && index != config(:states).length
						end
					end

					# *********************************************************
					# Period
					# *********************************************************

					#
					# Period
					#
					enum_column :period, ["full", "week"], default: "full"

				end

				module ClassMethods
					
					# *********************************************************
					# STI
					# *********************************************************

					#
					# Get available STI types
					#
					def types
						config(:types)
					end

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Columns permitted to be updated via request
					#
					def permitted_columns
						result = []
						if config(:states)
							config(:states).each_with_index do |state_spec, index|
								result << "time_window_#{state_spec[:name]}".to_sym if index != 0 && index != config(:states).length
							end
						end	
						result << :name
						result << :valid_from
						result << :valid_to
						result << :period
						result << :owner_reservation_limit
						result << { :opening_hours => [:min, :max] }
						return result
					end

				end

				# *************************************************************
				# Reservations
				# *************************************************************

				#
				# Create new reservation for given schedule and owner
				#
				def create_reservation(subject, owner = nil)
					
					# Create reservation
					reservation = _create_reservation(subject, owner)

					# Store
					reservation.save

					return reservation
				end

				#
				# Validate new reservation for given schedule and owner
				#
				def validate_reservation(subject, owner = nil)

					# Create reservation
					reservation = _create_reservation(subject, owner)

					# Validate
					reservation.valid?

					return reservation
				end	

				# *************************************************************
				# State
				# *************************************************************

				#
				# State
				#
				#state_column :state, config(:states).map { |state_spec| state_spec[:name] }
				
				#
				# Get state according to datetime
				#
				def _state(datetime)
					
					# Now
					now = Time.current
					
					# States
					states = config(:states)

					# Break times
					break_times = [datetime]
					states.reverse_each_with_index do |state_spec, index|
						if index != 0 && index != (states.length - 1) # Do not consider first and last state
							state_name = state_spec[:name]
							time_window = self.send("time_window_#{state_name}")
							if time_window
								break_times << (break_times.last - time_window.days_since_new_year.days - time_window.seconds_since_midnight.seconds)
							else
								break_times << break_times.last
							end
						end
					end

					# State recognititon
					result_state = nil
					result_state_behavior = nil
					states.each_with_index do |state_spec, index|
						if index < states.length - 1
							if now < break_times[states.length - 2 - index]
								result_state = state_spec[:name].to_sym
								result_state_behavior = state_spec[:behavior].to_sym
								break
							end
						else # Last fallback state
							result_state = state_spec[:name].to_sym
							result_state_behavior = state_spec[:behavior].to_sym
							break
						end
					end
					
					return [result_state, result_state_behavior]
				end

				#
				# Get state according to datetime
				#
				def state(datetime)
					result_state, result_state_behavior = _state(datetime)
					return result_state
				end

				#
				# Get state behavior according to datetime
				#
				def state_behavior(datetime)
					result_state, result_state_behavior = _state(datetime)
					return result_state_behavior
				end

			protected

				# *************************************************************
				# Reservations
				# *************************************************************

				#
				# Create new reservation object according to subject and owner
				#
				def _create_reservation(subject, owner = nil)
					
					# Create reservation
					reservation = RicReservation.reservation_model.new
					reservation.kind = "resource"
					reservation.resource_id = self.id

					# Bind subject
					reservation.schedule_date = subject.date
					reservation.schedule_from = subject.from
					reservation.schedule_to = subject.to
					reservation.subject = subject
					
					# Bind owner
					if !owner.nil?
						reservation.owner_id = owner.id if !owner.id.nil?
						reservation.owner_name = owner.name if !owner.name.nil?
					end

					return reservation
				end

				# *************************************************************
				# Callbacks
				# *************************************************************


				# *************************************************************
				# Validators
				# *************************************************************

			end
		end
	end
end
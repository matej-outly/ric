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
					# One-to-many relation with reservations
					#
					has_many :reservations, -> { where(kind: "resource") }, class_name: RicReservation.reservation_model.to_s, as: :resource, dependent: :destroy	

					# *********************************************************
					# Time windows / states
					# *********************************************************

					#
					# Define time windows as duration
					# 
					if config(:reservation_states) && config(:reservation_state_policy) == "time_window"
						config(:reservation_states).each_with_index do |reservation_state_spec, index|
							duration_column "time_window_#{reservation_state_spec[:name]}".to_sym if index != 0 && index != config(:reservation_states).length
						end
					end

					#
					# State
					#
					if config(:reservation_states)
						state_column :reservation_state, config(:reservation_states).map { |reservation_state_spec| reservation_state_spec[:name] }
					end
					
					# *********************************************************
					# Period
					# *********************************************************

					#
					# Period
					#
					enum_column :period, ["full", "week"], default: "full"

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present
					#
					validates_presence_of :name
					
					#
					# Some columns must be present if period is week
					#
					validates :valid_from, presence: true, if: :period_week?

				end

				module ClassMethods
					
					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Columns permitted to be updated via request
					#
					def permitted_columns
						result = []
						result = result.concat(self.permitted_columns_for_validity)
						if config(:reservation_states)
							if config(:reservation_state_policy) == "time_fixed"
								config(:reservation_states).each_with_index do |reservation_state_spec, index|
									result << "time_fixed_#{reservation_state_spec[:name]}".to_sym if index != 0
								end
							else
								config(:reservation_states).each_with_index do |reservation_state_spec, index|
									result << "time_window_#{reservation_state_spec[:name]}".to_sym if index != 0 && index != config(:reservation_states).length
								end
							end
						end	
						result << :name
						result << :period
						result << :owner_reservation_limit
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
				# Get reservation_state according to datetime
				#
				def _reservation_state(base)
					
					# Now
					now = Time.current
					
					# States
					reservation_states = config(:reservation_states)

					# Break times
					if config(:reservation_state_policy) == "time_fixed"
						break_times = []
						reservation_states.reverse_each_with_index do |reservation_state_spec, index|
							if index != 0 # Do not consider first state
								reservation_state_name = reservation_state_spec[:name]
								time_fixed = self.send("time_fixed_#{reservation_state_name}")
								if time_fixed
									break_times << time_fixed
								else
									break_times << break_times.last
								end
							end
						end
					else
						break_times = [base]
						reservation_states.reverse_each_with_index do |reservation_state_spec, index|
							if index != 0 && index != (reservation_states.length - 1) # Do not consider first and last reservation_state
								reservation_state_name = reservation_state_spec[:name]
								time_window = self.send("time_window_#{reservation_state_name}")
								if time_window
									break_times << (break_times.last - time_window.days_since_new_year.days - time_window.seconds_since_midnight.seconds)
								else
									break_times << break_times.last
								end
							end
						end
					end

					# State recognititon
					result_reservation_state = nil
					result_reservation_state_behavior = nil
					reservation_states.each_with_index do |reservation_state_spec, index|
						if index < reservation_states.length - 1
							if !break_times[reservation_states.length - 2 - index].nil? && now < break_times[reservation_states.length - 2 - index]
								result_reservation_state = reservation_state_spec[:name].to_sym
								result_reservation_state_behavior = reservation_state_spec[:behavior].to_sym
								break
							end
						else # Last fallback state
							result_reservation_state = reservation_state_spec[:name].to_sym
							result_reservation_state_behavior = reservation_state_spec[:behavior].to_sym
							break
						end
					end
					
					return [result_reservation_state, result_reservation_state_behavior]
				end

				#
				# Get state according to datetime
				#
				def reservation_state(base = Date.today)
					result_reservation_state, result_reservation_state_behavior = _reservation_state(base)
					return result_reservation_state
				end

				#
				# Get state behavior according to datetime
				#
				def reservation_state_behavior(base = Date.today)
					result_reservation_state, result_reservation_state_behavior = _reservation_state(base)
					return result_reservation_state_behavior
				end

				# *************************************************************
				# Period
				# *************************************************************

				#
				# Is period full?
				#
				def period_full?
					self.period == "full"
				end

				#
				# Is period week?
				#
				def period_week?
					self.period == "week"
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
					reservation.resource = self

					# Bind subject
					reservation.date_from = subject.date_from
					reservation.time_from = subject.time_from
					reservation.date_to = subject.date_to
					reservation.time_to = subject.time_to
					reservation.subject = subject
					
					# Bind owner
					if !owner.nil?
						reservation.owner_name = owner.name if !owner.name.nil?
						reservation.owner = owner if owner.is_a?(ActiveRecord::Base) # In case owner is not ActiveRecord, only name can be stored
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
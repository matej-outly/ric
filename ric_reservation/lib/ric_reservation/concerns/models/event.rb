# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event - capacity, size, reservation state, etc.
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module Event extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					#has_many :reservations, class_name: RicReservation.reservation_model.to_s
					# TODO reservations binded to scheduled event instead of simple event. Anyway
					# this solution lacks dependent: :destroy or :nullify ability


					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :capacity

					# *********************************************************
					# Time windows / reservation states
					# *********************************************************

					#
					# Define time windows as duration
					# 
					if config(:reservation_states) 
						if config(:reservation_state_policy) == "time_fixed"
							config(:reservation_states).each_with_index do |reservation_reservation_state_spec, index|
								if index != 0 # Ignore first state

									# Column name
									new_column = "time_fixed_#{reservation_reservation_state_spec[:name]}".to_sym

									# Redefine getter
									define_method(new_column) do
										column = new_column
										value = read_attribute(column)
										if value.nil? && self.resource
											value = self.resource.send(column)
										end
										return value
									end

								end
							end
						else
							config(:reservation_states).each_with_index do |reservation_reservation_state_spec, index|
								if index != 0 && index != config(:reservation_states).length # Ignore first and last state

									# Column name
									new_column = "time_window_#{reservation_reservation_state_spec[:name]}".to_sym

									# Duration column
									duration_column new_column 

									# Redefine getter
									define_method(new_column) do
										column = new_column
										value = read_attribute(column)
										if value.nil? && self.resource
											value = self.resource.send(column)
										end
										return value
									end

									# Redefine formatted getter
									define_method((new_column.to_s + "_formatted").to_sym) do
										column = new_column
										if read_attribute(column.to_s).nil? && self.resource
											return self.resource.send(new_column.to_s + "_formatted")
										else
											value = read_attribute(column.to_s)
											return nil if value.blank?
											days = value.days_since_new_year
											hours = value.hour
											minutes = value.min
											seconds = value.sec
											result = []
											result << days.to_s + " " + I18n.t("general.attribute.duration.days").downcase_first if days > 0
											result << hours.to_s + " " + I18n.t("general.attribute.duration.hours").downcase_first if hours > 0
											result << minutes.to_s + " " + I18n.t("general.attribute.duration.minutes").downcase_first if minutes > 0
											result << seconds.to_s + " " + I18n.t("general.attribute.duration.seconds").downcase_first if seconds > 0
											return result.join(", ")
										end
									end

								end
							end
						end
					
						#
						# Reservation state
						#
						state_column :reservation_state, config(:reservation_states).map { |reservation_reservation_state_spec| reservation_reservation_state_spec[:name] }
					
					end

					# *********************************************************
					# Reservations
					# *********************************************************

					#
					# All existing reservations must be synchronizied wih the data update
					#
					before_save :synchronize_reservations_before_save

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************
					
					#
					# Columns permitted to be updated via request
					#
					def permitted_columns_for_reservation_event
						result = []
						if config(:reservation_states)
							if config(:reservation_state_policy) == "time_fixed"
								config(:reservation_states).each_with_index do |reservation_reservation_state_spec, index|
									result << "time_fixed_#{reservation_reservation_state_spec[:name]}".to_sym if index != 0
								end
							else
								config(:reservation_states).each_with_index do |reservation_reservation_state_spec, index|
									result << "time_window_#{reservation_reservation_state_spec[:name]}".to_sym if index != 0 && index != config(:states).length
								end
							end
						end	
						result << self.resource_id_column
						result << :capacity
						result << :owner_reservation_limit
						return result
					end

					# *********************************************************
					# Resource
					# *********************************************************

					#
					# Get resource id column name - to be overriden in actual model
					#
					def resource_id_column
						raise "Not implemented."
					end

					#
					# Get resource type - to be overriden in actual model
					#
					def resource_type
						raise "Not implemented."
					end

					# *********************************************************
					# Overlapping TODO: make compatible with RicCalendar, other periods than ONCE
					# *********************************************************

					def overlaps_with_resource_reservation(resource_reservation)
						where(
							"
								(#{ActiveRecord::Base.connection.quote_column_name("period")} = :period_once) AND 
								(#{ActiveRecord::Base.connection.quote_column_name("from")} < :to) AND 
								(:from < #{ActiveRecord::Base.connection.quote_column_name("to")})
							", 
							from: resource_reservation.schedule_from, 
							to: resource_reservation.schedule_to, 
							period_once: "once"
						)
					end

					# *********************************************************
					# Reservation
					# *********************************************************

					def with_reservation_by(owner)
						if owner.nil?
							all
						else
							joins("LEFT OUTER JOIN reservations ON reservations.event_id = #{self.table_name}.id AND reservations.event_type = #{ActiveRecord::Base.connection.quote(self.name)}")
								.where(reservations: { owner_id: owner.id, owner_type: owner.class.name })
								.group("#{self.table_name}.id")
						end
					end

				end

				# *************************************************************
				# Resource
				# *************************************************************
				
				#
				# Get resource id
				#
				def resource_id
					return self.send(self.class.resource_id_column)
				end

				#
				# Get resource type
				#
				def resource_type
					return self.class.resource_type
				end

				#
				# Get resource object
				#
				def resource
					if @resource.nil?
						begin
							@resource = self.resource_type.constantize.find_by_id(self.resource_id)
						rescue
						end
					end
					return @resource
				end

				# *************************************************************
				# Owner reservation limit
				# *************************************************************

				#
				# Get owner reservation limit
				#
				def owner_reservation_limit
					value = read_attribute(:owner_reservation_limit)
					if value.nil? && self.resource
						value = self.resource.owner_reservation_limit
					end
					return value
				end

				# *************************************************************
				# Reservation state
				# *************************************************************

				#
				# Get reservation state according to date
				#
				def reservation_state(base = self.date_from)
					@reservation_states = {} if @reservation_state.nil?
					@reservation_state_behaviors = {} if @reservation_state_behaviors.nil?
					if @reservation_states[base.to_s].nil?
						
						# Now
						now = Time.current
						
						# States
						reservation_states = config(:reservation_states)

						# Break times
						if config(:reservation_state_policy) == "time_fixed"
							break_times = []
							reservation_states.reverse_each_with_index do |reservation_state_spec, index|
								if index != 0 # Do not consider first state
									state_name = reservation_state_spec[:name]
									time_fixed = self.send("time_fixed_#{state_name}")
									if time_fixed
										break_times << time_fixed
									else
										break_times << break_times.last
									end
								end
							end
						else
							break_times = [self.datetime_from(base)]
							reservation_states.reverse_each_with_index do |reservation_state_spec, index|
								if index != 0 && index != (reservation_states.length - 1) # Do not consider first and last state
									state_name = reservation_state_spec[:name]
									time_window = self.send("time_window_#{state_name}")
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
								if !break_times[reservation_states.length - 2 - index].nil? && now < break_times[reservation_states.length - 2 - index]
									@reservation_states[base.to_s] = reservation_state_spec[:name].to_sym
									@reservation_state_behaviors[base.to_s] = reservation_state_spec[:behavior].to_sym
									break
								end
							else # Last fallback state
								@reservation_states[base.to_s] = reservation_state_spec[:name].to_sym
								@reservation_state_behaviors[base.to_s] = reservation_state_spec[:behavior].to_sym
								break
							end
						end
					end
					return @reservation_states[base.to_s]
				end

				#
				# Get reservation state behavior according to current state
				#
				def reservation_state_behavior(base = self.date_from)
					if @reservation_state_behaviors.nil? || @reservation_state_behaviors[base.to_s].nil?
						self.reservation_state
					end
					return @reservation_state_behaviors[base.to_s]
				end

				# *************************************************************
				# Reservations
				# *************************************************************

				#
				# Get all reservations 
				#
				def reservations(base = self.date_from)
					@reservations = {} if @reservations.nil?
					if @reservations[base.to_s].nil?
						@reservations[base.to_s] = RicReservation.reservation_model.event(self, base)
					end
					return @reservations[base.to_s]
				end

				#
				# Create new reservation for given subject and owner
				#
				def create_reservation(base = self.date_from, subject = nil, owner = nil)
					
					# Create reservation
					reservation = _create_resevation(base, subject, owner)

					# Store
					reservation.save

					return reservation
				end

				#
				# Validate new reservation for given subject and owner
				#
				def validate_reservation(base = self.date_from, subject = nil, owner = nil)
					
					# Create reservation
					reservation = _create_resevation(base, subject, owner)

					# Validate
					reservation.valid?

					return reservation
				end

				# *************************************************************
				# Capacity / size
				# *************************************************************

				#
				# Default reservation size - to be overriden in model
				# 
				def default_reservation_size
					1
				end

				#
				# Default capacity kind - to be overriden in model
				# 
				def capacity_type
					:integer
				end
				
				#
				# Get current capacity (based on defined capacity/size type)
				#
				def capacity
					return self.send("capacity_#{self.capacity_type.to_s}")
				end

				#
				# Set current capacity (based on defined capacity/size type)
				#
				def capacity=(capacity)
					self.send("capacity_#{self.capacity_type.to_s}=", capacity)
				end

				#
				# Get current event size in case capacity/size type is integer
				#
				def size_integer(base = self.date_from)
					@sizes = {} if @sizes.nil?
					if @sizes[base.to_s].nil?
						size = 0
						self.reservations(base).each do |reservation|
							if reservation.above_line?
								size += reservation.size
							end
						end
						@sizes[base.to_s] = size
					end
					return @sizes[base.to_s]
				end

				#
				# Get current event size in case capacity/size type is time
				#
				def size_time(base = self.date_from)
					@sizes = {} if @sizes.nil?
					if @sizes[base.to_s].nil?
						size = DateTime.parse("2000-01-01 00:00:00 +0000")
						self.reservations(base).each do |reservation|
							if reservation.above_line?
								size += reservation.size.seconds_since_midnight.seconds
							end
						end
						@sizes[base.to_s] = size
					end
					return @sizes[base.to_s]
				end

				#
				# Get current event size (based on defined capacity/size type)
				#
				def size(base = self.date_from)
					return self.send("size_#{self.capacity_type.to_s}", base)
				end

				#
				# (Scheduled) event is at capacity and no other reservations can be created
				#
				def at_capacity?(base = self.date_from)
					@at_capacities = {} if @at_capacities.nil?
					if @at_capacities[base.to_s].nil?
						@at_capacities[base.to_s] = (self.size(base) >= self.capacity)
					end
					return @at_capacities[base.to_s]
				end

			protected

				# *************************************************************
				# Reservations
				# *************************************************************

				#
				# Create new reservation object according to given subject and owner
				#
				def _create_resevation(base, subject, owner)
					
					# Create reservation
					reservation = RicReservation.reservation_model.new
					reservation.kind = "event"
					reservation.event = self
					reservation.date_from = base
					reservation.date_to = base + (self.date_to - self.date_from).to_i.days
					reservation.time_from = self.time_from
					reservation.time_to = self.time_to

					# Bind subject
					if !subject.nil?
						reservation.size = subject.size
						reservation.subject = subject
					else
						reservation.size = self.default_reservation_size
					end

					# Bind owner
					if !owner.nil?
						reservation.owner_name = owner.name if !owner.name.nil?
						reservation.owner = owner if owner.is_a?(ActiveRecord::Base) # In case owner is not ActiveRecord, only name can be stored
					end

					return reservation
				end

				#
				# All existing reservations must be synchronizied wih the data update
				#
				def synchronize_reservations_before_save
					if !self.is_recurring?
						self.reservations(self.date_from_was).each do |reservation|
							reservation.date_from = self.date_from
							reservation.date_to = self.date_to
							reservation.time_from = self.time_from
							reservation.time_to = self.time_to
							reservation.save
						end
					else
						# TODO how to solve it for recurring events ???
					end
				end

			end
		end
	end
end
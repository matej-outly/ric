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
					# Scopes
					# *********************************************************

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
				# Get state according to datetime
				#
				def state(datetime)
					
					# Now
					now = Time.current
					
					# Break points
					if self.time_window_deadline
						deadline = datetime - self.time_window_deadline.seconds_since_midnight.seconds
					else
						deadline = datetime
					end
					if self.time_window_soon
						soon = deadline - self.time_window_soon.seconds_since_midnight.seconds
					else
						soon = deadline
					end

					# State recognititon
					if now < soon
						state = :open
					elsif now < deadline
						state = :soon
					elsif now < datetime
						state = :deadline
					else
						state = :closed
					end
					
					return state
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
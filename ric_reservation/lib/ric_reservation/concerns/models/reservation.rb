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

					#
					# One-to-many relation with resources
					#
					#belongs_to :resource, class_name: RicReservation.resource_model.to_s

					#
					# One-to-many relation with events
					#
					#belongs_to :event, class_name: RicReservation.event_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present (always)
					#
					validates_presence_of :kind, :schedule_from, :schedule_to

					#
					# Some columns must be present if kind is event
					#
					validates :event_id, presence: true, if: :kind_event?
					validates :schedule_date, presence: true, if: :kind_event?
					validates :size, presence: true, if: :kind_event?

					#
					# Some columns must be present if kind is resource
					#
					validates :resource_id, presence: true, if: :kind_resource?

					# *********************************************************
					# Kind
					# *********************************************************

					#
					# Kind
					#
					enum_column :kind, ["event", "resource"]

				end

				module ClassMethods

					# *********************************************************
					# Line
					# *********************************************************

					#
					# Scope for reservations above line
					#
					def above_line
						where("below_line = false OR below_line IS NULL")
					end

					#
					# Scope for reservations below line
					#
					def below_line
						where("below_line = true")
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
				# Line
				# *************************************************************

				#
				# Is reservation above line?
				#
				def above_line?
					return (self.below_line.nil? || self.below_line == false)
				end

				#
				# Is reservation below line?
				#
				def below_line?
					return (self.below_line == true)
				end

				# *************************************************************
				# Schedule time
				# *************************************************************

				#
				# Schedule time
				#
				def schedule_time
					return self.schedule_from.strftime("%k:%M") + " - " + self.schedule_to.strftime("%k:%M")
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
							deadline = self.schedule_from - self.event.time_window_deadline
							soon = deadline - self.event.time_window_soon
						else # if self.kind_resource?
							deadline = self.schedule_from - self.resource.time_window_deadline
							soon = deadline - self.resource.time_window_soon
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

				# *************************************************************
				# Event
				# *************************************************************

				#
				# Get (scheduled) event
				#
				def event
					if @event.nil?
						@event = RicReservation.event_model.find_by_id(self.event_id)
						if @event
							@event.schedule(self.schedule_date)
						else
							@event = false
						end
					end
					return @event
				end

				#
				# Get (scheduled) event valid for schedule date of false if not any
				#
				def valid_event
					if @valid_event.nil?
						@valid_event = RicReservation.event_model.valid(self.schedule_date).where(id: self.event_id).first
						if @valid_event
							@valid_event.schedule(self.schedule_date)
						else
							@valid_event = false
						end
					end
					return @valid_event
				end

				# *************************************************************
				# Resource
				# *************************************************************

				# TODO
				
				# *************************************************************
				# Below line
				# *************************************************************

				# TODO

			protected

			end
		end
	end
end
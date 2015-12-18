# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event reservation
# *
# * Author: Matěj Outlý
# * Date  : 18. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module EventReservation extend ActiveSupport::Concern

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
					#belongs_to :event, class_name: RicReservation.event_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present if kind is event
					#
					validates :event_id, presence: true, if: :kind_event?
					validates :schedule_date, presence: true, if: :kind_event?
					validates :size, presence: true, if: :kind_event?

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
				# Below line
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

				# TODO

			end
		end
	end
end
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

					#
					# Reservation can't be over capacity
					#
					validate :validate_capacity

				end

				module ClassMethods

					# *********************************************************
					# Kind
					# *********************************************************

					#
					# Scope for event reservations
					#
					def event(event = nil, schedule_date = nil)
						result = where(kind: "event")
						result = result.where(event_id: event.id) if event
						result = result.where(schedule_date: schedule_date) if schedule_date
						return result
					end

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

			protected

				#
				# Event capacity can't be overdrawn
				#
				def validate_capacity
					return if !self.kind_event?

					if self.new_record?
						size_diff = self.size
					else
						size_diff = self.size - self.size_was
					end

					# Check event size
					if self.event.size + size_diff > self.event.capacity
						errors.add(:size, "activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.capacity_overdraw")
					end

				end

			end
		end
	end
end
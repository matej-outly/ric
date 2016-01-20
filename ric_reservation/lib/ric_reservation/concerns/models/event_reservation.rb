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
					# Event can't be over capacity
					#
					validate :validate_capacity

					#
					# Event reservation limit can't be overdrawn
					#
					validate :validate_owner_reservation_limit

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

				#
				# Put reservation above line manually
				#
				def put_above_line
					self.below_line = nil
					self.save
					#self.inform_above_line
				end

				#
				# Put reservation below line manually
				#
				def put_below_line
					self.below_line = true
					self.save
					#self.inform_below_line
				end

				#
				# TODO
				#
				def process_above_line(event_id, schedule_date)
					
				end

				# *************************************************************
				# Conditions
				# *************************************************************

				#
				# Check if capacity condition valid => returns true if OK
				#
				def check_capacity
					if self.new_record? || self.below_line?
						size_diff = self.size
					else
						size_diff = self.size - self.size_was
					end
					return self.event.size + size_diff <= self.event.capacity
				end

				#
				# Check if owner reservation limit condition valid => returns true if OK
				#
				def check_owner_reservation_limit
					
					# No limit
					return true if self.event.owner_reservation_limit.nil?

					# No owner
					return true if self.owner_id.nil?

					# Limit is equal or overdrawn => No other reservation can be created
					if self.id
						return (RicReservation.reservation_model
							.event(self.event, self.schedule_date)
							.above_line
							.where("id <> :id", id: self.id)
							.where(owner_id: self.owner_id).count < self.event.owner_reservation_limit)
					else
						return (RicReservation.reservation_model
							.event(self.event, self.schedule_date)
							.above_line
							.where(owner_id: self.owner_id).count < self.event.owner_reservation_limit)
					end
				end

				#
				# Check if reservation can be put above line
				#
				def check_above_line
					result = true

					# Check capacity
					result &= check_capacity

					# Check owner reservation limit
					result &= check_owner_reservation_limit

					return result
				end

			protected

				# *************************************************************
				# Validators
				# *************************************************************

				#
				# Event capacity can't be overdrawn
				#
				def validate_capacity
					return if !self.kind_event?
					if !check_capacity
						if RicReservation.event_model.config(:enable_below_line) == true
							self.below_line = true
						else
							errors.add(:size, "activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.capacity_overdraw")
						end
					end

				end

				#
				# Event reservation limit can't be overdrawn
				#
				def validate_owner_reservation_limit
					return if !self.kind_event?
					if !check_owner_reservation_limit
						if RicReservation.event_model.config(:enable_below_line) == true
							self.below_line = true
						else
							errors.add(:owner_id, I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.owner_reservation_limit_overdraw"))
						end
					end
				end

			end
		end
	end
end
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

					belongs_to :event, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present if kind is event
					#
					validates :event_id, presence: true, if: :kind_event?
					validates :event_type, presence: true, if: :kind_event?
					validates :size, presence: true, if: :kind_event?

					#
					# Event can't be over capacity
					#
					validate :validate_capacity

					#
					# Event reservation limit can't be overdrawn
					#
					validate :validate_owner_reservation_limit

					# *********************************************************
					# Line
					# *********************************************************

					after_destroy :enqueue_for_process_above_line

				end

				module ClassMethods

					# *********************************************************
					# Kind
					# *********************************************************

					#
					# Scope for event reservations
					#
					def event(event = nil, date_from = nil)
						result = where(kind: "event")
						result = result.where(event_id: event.id, event_type: event.class.name) if event
						result = result.where(date_from: date_from) if date_from
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

					#
					# Process above line possibility
					#
					def process_above_line(event_type, event_id, date_from)
							
						# Check valid event
						event = nil
						begin
							event = event_type.constantize.find_by_id(event_id)
						rescue
						end
						if event.nil?
							return false
						end
					
						RicReservation.reservation_model.transaction do 

							# Get all reservations below line
							reservations = event(event, date_from).below_line.order(created_at: :asc)
							
							# Check all reservations for possibility to put above line
							reservations.each do |reservation|
								if reservation.check_above_line
									#reservation.put_above_line
								end
							end

						end

						return true
					end

				end

				# *************************************************************
				# Event
				# *************************************************************

				#
				# Get (scheduled) event
				#
				def event
					result = super
					#if result
					#	result.schedule(self.schedule_date)
					#end
					return result
				end

				#
				# Get (scheduled) event valid for schedule date of nil if not any
				#
				def valid_event
					result = self.event
					if result && !result.is_valid?(self.schedule_date)
						result = nil
					end
					return result
				end

				# *************************************************************
				# Size
				# *************************************************************

				#
				# Get current size (based on defined capacity type)
				#
				def size
					if self.event.nil?
						raise "Please bind valid event first."
					end
					return self.send("size_#{self.event.capacity_type.to_s}")
				end

				#
				# Set current size (based on defined capacity type)
				#
				def size=(size)
					if self.event.nil?
						raise "Please bind valid event first."
					end
					self.send("size_#{self.event.capacity_type.to_s}=", size)
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

				#
				# Put reservation above line manually
				#
				def put_above_line
					self.below_line = nil
					self.save
					self.notify(:reservation_above_line)
				end

				#
				# Put reservation below line manually
				#
				def put_below_line
					self.below_line = true
					self.save
					self.notify(:reservation_below_line)
				end


				# *************************************************************
				# Conditions
				# *************************************************************

				#
				# Check if capacity (integer) condition valid => returns true if OK
				#
				def check_capacity_integer
					if self.new_record? || self.below_line?
						size_diff = self.size_integer
					else
						size_diff = self.size_integer - self.size_integer_was
					end
					return self.event.size + size_diff <= self.event.capacity
				end

				#
				# Check if capacity (time) condition valid => returns true if OK
				#
				def check_capacity_time
					if self.new_record? || self.below_line?
						size_diff = self.size_time.seconds_since_midnight.seconds
					else
						size_diff = (self.size_time.seconds_since_midnight - self.size_time_was.seconds_since_midnight).seconds
					end
					return self.event.size + size_diff <= self.event.capacity
				end

				#
				# Check if capacity condition valid => returns true if OK
				#
				def check_capacity
					if self.event.nil?
						raise "Please bind valid event first."
					end
					return self.send("check_capacity_#{self.event.capacity_type.to_s}")
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
							.event(self.event, self.date_from)
							.above_line
							.where("id <> :id", id: self.id)
							.where(owner_id: self.owner_id, owner_type: self.owner_type).count < self.event.owner_reservation_limit)
					else
						return (RicReservation.reservation_model
							.event(self.event, self.date_from)
							.above_line
							.where(owner_id: self.owner_id, owner_type: self.owner_type).count < self.event.owner_reservation_limit)
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
				# Line
				# *************************************************************

				def enqueue_for_process_above_line
					return if !self.kind_event?
					if self.event.config(:enable_below_line) == true
						QC.enqueue("#{RicReservation.reservation_model.to_s}.process_above_line", self.event_type, self.event_id, self.date_from)
					end
				end

				# *************************************************************
				# Validators
				# *************************************************************

				#
				# Event capacity can't be overdrawn
				#
				def validate_capacity
					return if !self.kind_event?
					if !check_capacity
						if self.event.config(:enable_below_line) == true
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
						if self.event.config(:enable_below_line) == true
							self.below_line = true
						else
							errors.add(:owner_id, I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.owner_reservation_limit_overdraw"))
						end
					end
				end

				# *************************************************************
				# Notification
				# *************************************************************

				def notify(message)
					return if defined?(RicNotification).nil?
					return if self.owner.nil?

					# Get receiver object
					if self.owner_type == RicNotification.user_model
						receiver = self.owner
					else
						receiver = self.owner.user
					end

					# Notify receiver
					RicNotification.notify([message, self], receiver)
				end

			end
		end
	end
end
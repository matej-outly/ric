# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Resource reservation
# *
# * Author: Matěj Outlý
# * Date  : 18. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module ResourceReservation extend ActiveSupport::Concern

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
					# One-to-many relation with resources
					#
					belongs_to :resource, class_name: RicReservation.resource_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present if kind is resource
					#
					validates :resource_id, presence: true, if: :kind_resource?

					#
					# Reservations and event can't overlap 
					#
					validate :validate_overlapping

				end

				module ClassMethods

					# *********************************************************
					# Kind
					# *********************************************************

					#
					# Scope for resource reservations
					#
					def resource(resource = nil)
						result = where(kind: "resource")
						result = result.where(resource_id: resource.id) if resource
						return result
					end

					# *********************************************************
					# Schedule
					# *********************************************************

					#
					# Scope for reservarions in some schedule
					#
					def schedule(date_from, date_to = nil)
						date_to = date_from + 1.day if date_to.nil?
						where(":date_from < schedule_date AND schedule_date < :date_to", date_from: date_from, date_to: date_to)
					end

					# *********************************************************
					# Overlapping
					# *********************************************************

					def overlaps_with_resource_reservation(resource_reservation)
						where("(schedule_from < :to) AND (:from < schedule_to)", from: resource_reservation.schedule_from, to: resource_reservation.schedule_to)
					end

					def overlaps_with_event(event)
						where("(schedule_from < :to) AND (:from < schedule_to)", from: event.from, to: event.to)
					end

				end

			protected

				# *************************************************************
				# Validators
				# *************************************************************

				def validate_overlapping
					return if !self.kind_resource?

					if	(self.id && RicReservation.reservation_model.resource(self.resource).where("id <> :id", id: self.id).overlaps_with_resource_reservation(self).count > 0) || # With other resource reservations
						(!self.id && RicReservation.reservation_model.resource(self.resource).overlaps_with_resource_reservation(self).count > 0) || # With other resource reservations
						(RicReservation.event_model.where(resource_id: self.resource_id).overlaps_with_resource_reservation(self).count > 0) # With other events in the same resource

						message = I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.overlapping")
						errors.add(:schedule_date, message)
						errors.add(:schedule_from, message)
						errors.add(:schedule_to, message)
					end
				end

			end
		end
	end
end
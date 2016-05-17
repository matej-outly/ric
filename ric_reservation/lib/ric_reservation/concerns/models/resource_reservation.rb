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
					belongs_to :resource, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present if kind is resource
					#
					validates :resource_id, presence: true, if: :kind_resource?
					validates :resource_type, presence: true, if: :kind_resource?

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
						result = result.where(resource_id: resource.id) if resource # TODO resource type
						return result
					end

					# *********************************************************
					# Overlapping
					# *********************************************************

					def overlaps_with_resource_reservation(resource_reservation)
						where(
							"
								(schedule_from < :to) AND 
								(:from < schedule_to)
							", 
							from: resource_reservation.schedule_from, 
							to: resource_reservation.schedule_to
						)
					end

					#def overlaps_with_event(event) # TODO: Other periods than ONCE
					#	where(
					#		"
					#			(schedule_from < :to) AND 
					#			(:from < schedule_to)
					#		", 
					#		from: event.from, 
					#		to: event.to
					#	)
					#end

				end

			protected

				# *************************************************************
				# Conditions
				# *************************************************************

				def check_overlapping
					result = true
					if self.id
						result &= (RicReservation.reservation_model
							.resource(self.resource)
							.where("id <> :id", id: self.id)
							.overlaps_with_resource_reservation(self).count == 0) # With other resource reservations
					else
						result &= (RicReservation.reservation_model
							.resource(self.resource)
							.overlaps_with_resource_reservation(self).count == 0) # With other resource reservations
					end
					result &= (RicReservation.event_model
						.where(resource_id: self.resource_id)
						.overlaps_with_resource_reservation(self).count == 0) # With other events in the same resource
					return result
				end

				# *************************************************************
				# Validators
				# *************************************************************

				def validate_overlapping
					return if !self.kind_resource?
					if !check_overlapping
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
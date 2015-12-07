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
					#has_many :reservations, class_name: RicReservation.reservation_model.to_s
					# TODO dependent: :destroy

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

			protected

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
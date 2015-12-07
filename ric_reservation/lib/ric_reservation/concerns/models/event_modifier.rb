# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event modifier
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module EventModifier extend ActiveSupport::Concern

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
					belongs_to :event, class_name: RicReservation.event_model.to_s

				end

				module ClassMethods
					
					# *********************************************************
					# Scopes
					# *********************************************************

					#
					# Scope for "tmp cancel"
					#
					def tmp_canceled
						where("tmp_canceled = true")
					end

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
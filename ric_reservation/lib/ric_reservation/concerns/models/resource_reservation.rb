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

				end

			end
		end
	end
end
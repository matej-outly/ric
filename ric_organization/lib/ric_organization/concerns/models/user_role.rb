# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User role
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module UserRole extend ActiveSupport::Concern

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def assigned_to(organization)
						where(user_id: organization.user_assignments.to_a.map { |user_assignment| user_assignment.user_id })
					end

				end

			end
		end
	end
end
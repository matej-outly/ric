# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User assignment
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module UserAssignment extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :organization, class_name: RicOrganization.organization_model.to_s
					belongs_to :user, class_name: RicOrganization.user_model.to_s
					belongs_to :organization_assignment, class_name: RicOrganization.organization_assignment_model.to_s if RicOrganization.enable_organization_assignments

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :organization_id, :user_id

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						return [
							:organization_assignment_id
							# ... define custom columns ...
						]#.concat(RicOrganization.user_model.permitted_columns)
					end

				end

			protected

			end
		end
	end
end
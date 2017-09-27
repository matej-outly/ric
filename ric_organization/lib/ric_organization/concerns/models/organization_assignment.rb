# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organization assignment
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module OrganizationAssignment extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :organization, class_name: RicOrganization.organization_model.to_s
					has_many :user_assignments, class_name: RicOrganization.user_assignment_model.to_s, dependent: :destroy

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :organization_id

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = [
							:name
						]
						return result
					end

				end

			end
		end
	end
end
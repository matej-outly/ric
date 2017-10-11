# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module User extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					# Organization
					has_many :user_assignments, class_name: RicOrganization.user_assignment_model.to_s, dependent: :destroy
					has_many :assigned_organizations, class_name: RicOrganization.organization_model.to_s, through: :user_assignments, source: :organization

				end

				# *************************************************************
				# Current organization
				# *************************************************************

				def current_organization
					if @current_organization.nil?
						user_role = self.user_roles.where.not(person_id: nil).first
						if user_role
							@current_organization = user_role.person
						end
					end
					return @current_organization
				end

				# TODO current organization overriding

			end
		end
	end
end
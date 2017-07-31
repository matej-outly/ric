# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organization
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module Organization extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					has_many :organization_assignments, class_name: RicOrganization.organization_assignment_model.to_s, dependent: :destroy
					has_many :actor_relations, as: :actor, class_name: RicOrganization.organization_relation_model.to_s, dependent: :destroy
					has_many :actee_relations, as: :actee, class_name: RicOrganization.organization_relation_model.to_s, dependent: :destroy

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = [
						]
						return result
					end

				end

			end
		end
	end
end
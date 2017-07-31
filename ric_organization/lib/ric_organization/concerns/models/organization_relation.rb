# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organization relation
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module OrganizationRelation extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :actor, class_name: RicOrganization.organization_model.to_s
					belongs_to :actee, class_name: RicOrganization.organization_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :actor_id, :actee_id

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
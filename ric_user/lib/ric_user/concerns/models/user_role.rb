# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User role
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module UserRole extend ActiveSupport::Concern

				included do

					# *********************************************************
					# User
					# *********************************************************

					belongs_to :user, class_name: RicUser.user_model.to_s
					validates_presence_of :user_id
					
					# *********************************************************
					# Role
					# *********************************************************

					if RicUser.use_static_roles
						enum_column :role, RicUser.roles
						validates_presence_of :role
					else
						belongs_to :role, class_name: RicUser.role_model.to_s
						validates_presence_of :role_id
					end

					# *********************************************************
					# Person
					# *********************************************************

					if RicUser.scope_user_role_by_person
						belongs_to :person, class_name: RicUser.user_role_person_model.to_s
						validates_presence_of :person_id
					end

				end

			end
		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Single-role user (static version)
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module User
				module SingleStaticRole extend ActiveSupport::Concern

					included do
						
						# *****************************************************
						# Role
						# *****************************************************

						enum_column :role, RicUser.roles, default: RicUser.default_role
						
					end

				end
			end
		end
	end
end
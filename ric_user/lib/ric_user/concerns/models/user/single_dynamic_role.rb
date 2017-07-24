# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Single-role user (dynamic version)
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module User
				module SingleDynamicRole extend ActiveSupport::Concern

					included do
						
						# *****************************************************
						# Role
						# *****************************************************

						belongs_to :role, class_name: RicUser.role_model.to_s

					end

					module ClassMethods

						def has_role?
							true
						end

					end
					
				end
			end
		end
	end
end
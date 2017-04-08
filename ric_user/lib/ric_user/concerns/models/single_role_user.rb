# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Single-role user
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module SingleRoleUser extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Role
					# *********************************************************

					#if has_role? # can't be here, because of DB migrations failing to complete the contidion
						enum_column :role, RicUser.roles, default: RicUser.default_role
					#end

				end

				module ClassMethods

					def has_role?
						self.column_names.include?("role")
					end

				end

			end
		end
	end
end
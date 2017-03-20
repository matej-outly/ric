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

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :user, class_name: RicUser.user_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :user_id, :role

					# *********************************************************
					# Role
					# *********************************************************

					enum_column :role, RicUser.roles

				end

			end
		end
	end
end
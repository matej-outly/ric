# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Multi-roles user (dynamic version)
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module User
				module MultiDynamicRoles extend ActiveSupport::Concern

					included do
						
						# *****************************************************
						# Structure
						# *****************************************************

						has_many :user_roles, class_name: RicUser.user_role_model.to_s, dependent: :destroy
						has_many :roles, class_name: RicUser.role_model.to_s, through: :user_roles

					end

					#
					# Get currently selected role, see current_role method
					#
					def role
						self.current_role
					end

					#
					# Set single role to DB (for compatibility with single-role user)
					#
					def role=(new_role)
						self.roles = new_role
					end

					# *********************************************************
					# Roles as set by application
					# *********************************************************

					#
					# Get currently selected role. Role can be selected by current_role= method
					#
					def current_role
						if @current_role.nil?
							RicUser.role_model.order(id: :asc).each do |role| # Get highest priority role
								if self.role_ids.include?(role.id)
									@current_role = role
									break
								end
							end
						end
						return @current_role
					end

					def current_role=(new_role)
						if self.role_ids.include?(new_role.id)
							@current_role = new_role
						else
							raise "Can't set role #{new_role.name} as current."
						end
					end

				end
			end
		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Multi-roles user
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module MultiRolesUser extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Roles
					# *********************************************************

					has_many :user_roles, class_name: RicUser.user_role_model.to_s

					# *********************************************************
					# Roles
					# *********************************************************

					enum_column :roles, RicUser.roles
					enum_column :role, RicUser.roles

				end

				#
				# Roles getter
				#
				def roles
					if @roles.nil?
						@roles = self.user_roles.order(role: :asc).to_a.map { |user_role| user_role.role }
					end
					return @roles
				end

				#
				# Roles setter
				#
				def roles=(new_roles)

					# Manage input / new roles
					new_roles = [new_roles.to_s] if !new_roles.is_a?(Array)
					new_roles.uniq!

					# Current roles
					current_roles = self.roles

					# User roles to remove
					user_roles_to_remove = []
					self.user_roles.each do |user_role|
						user_roles_to_remove << user_role if !new_roles.include?(user_role.role)
					end

					# Roles to add
					roles_to_add = []
					new_roles.each do |role|
						roles_to_add << role if !current_roles.include?(role)
					end

					# Perform DB actions
					self.transaction do
						user_roles_to_remove.each do |user_role|
							user_role.destroy
						end
						roles_to_add.each do |role|
							self.user_roles.create(role: role)
						end
					end

					# Clear cache
					@roles = nil

				end

				#
				# Highest priority role
				#
				def role
					if @role.nil?
						RicUser.roles.each do |role|
							if self.roles.include?(role)
								@role = role
								break
							end
						end
					end
					return @role
				end

				#
				# Set single role (for compatibility with single-role user)
				#
				def role=(new_role)
					self.roles = new_role
				end

			end
		end
	end
end
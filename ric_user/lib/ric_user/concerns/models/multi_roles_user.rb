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
					# Structure
					# *********************************************************

					has_many :user_roles, class_name: RicUser.user_role_model.to_s

					# *********************************************************
					# Roles
					# *********************************************************

					enum_column :roles, RicUser.roles
					enum_column :role, RicUser.roles

				end

				module ClassMethods

					def role_obj(role)
						self.available_roles.find { |r| r.value == role }
					end

				end

				# *************************************************************
				# Roles as set in DB
				# *************************************************************

				#
				# Get all roles
				#
				def roles
					if @roles.nil?
						@roles = self.user_roles.order(role: :asc).to_a.map { |user_role| user_role.role }
					end
					return @roles
				end

				#
				# Set roles to DB
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
						roles_to_add << role.to_s if !current_roles.include?(role.to_s)
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

				# *************************************************************
				# Roles as set by application
				# *************************************************************

				#
				# Get currently selected role. Role can be selected by current_role= method
				#
				def current_role
					if @current_role.nil?
						RicUser.roles.each do |role| # Get highest priority role
							if self.roles.include?(role)
								@current_role = role
								break
							end
						end
					end
					return @current_role
				end

				def current_role=(new_role)
					if self.roles.include?(new_role)
						@current_role = new_role.to_s
					else
						raise "Can't set role #{new_role} as current."
					end
				end

			end
		end
	end
end
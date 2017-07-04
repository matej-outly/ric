# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Multi-roles user (static version)
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module User
				module MultiStaticRoles extend ActiveSupport::Concern

					included do
						
						# *****************************************************
						# User roles
						# *****************************************************

						has_many :user_roles, class_name: RicUser.user_role_model.to_s, dependent: :destroy

						# *****************************************************
						# Roles
						# *****************************************************

						enum_column :roles, RicUser.roles
						enum_column :role, RicUser.roles
						after_save :update_roles

					end

					module ClassMethods

						def role_obj(role)
							self.available_roles.find { |r| r.value == role }
						end

					end

					# *********************************************************
					# Roles as set in DB
					# *********************************************************

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
						if new_roles.blank?
							new_roles = []
						else
							new_roles = [new_roles.to_s] if !new_roles.is_a?(Array)
							new_roles.uniq!
						end

						# Store for later update
						#@roles_was = self.roles if @roles_was.nil?
						@roles_changed = true
						@roles = new_roles
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

				protected

					def update_roles
						if @roles_changed == true

							# Perform DB actions
							self.transaction do
								self.user_roles.diff(@roles, compare_attr_1: :role) do |action, item|
									if action == :add
										self.user_roles.create(role: item)
									elsif action == :remove
										item.destroy
									end
								end
							end

							# Clear cache
							@roles = nil
							@roles_changed = nil
							self.user_roles.reset
						end
						return true
					end

				end
			end
		end
	end
end
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

						# *********************************************************
						# Helper for roles assigning
						# *********************************************************

						if RicUser.scope_user_role_by_person
							define_method :assign_role_ids_scoped_by_person do |new_role_ids, person|
								if !new_role_ids.nil?
									current_role_ids = self.user_roles.where(person_id: person.id).map{ |user_role| user_role.role_id }
									Array.diff(current_role_ids, new_role_ids) do |action, role_id|
										if action == :add
											self.user_roles.create(role_id: role_id, person_id: person.id)
										elsif action == :remove
											self.user_roles.where(role_id: role_id, person_id: person.id).destroy_all
										end
									end
								end
							end
						end

					end

					module ClassMethods

						def has_role?
							false
						end

						def has_roles?
							true
						end
					
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
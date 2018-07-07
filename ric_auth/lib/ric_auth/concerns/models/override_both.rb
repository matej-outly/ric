# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Override
# *
# * Author: Matěj Outlý
# * Date  : 28. 4. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Models
			module OverrideBoth extend ActiveSupport::Concern

				included do
					attr_accessor :role_ref
					attr_accessor :user_id
				end

				module ClassMethods

					def session_key
						"auth_overrides"
					end

					def permitted_columns
						[
							:role_ref,
							:user_id
						]
					end

				end

				# *************************************************************
				# Attributes
				# *************************************************************

				#
				# Fake ID
				#
				def id
					1
				end

				#
				# User object
				#
				def user
					if @user.nil? && !self.user_id.blank?
						@user = RicAuth.user_model.find_by_id(self.user_id)
					end
					return @user
				end

				#
				# Role
				#
				def role
					if @role.nil?
						@role = RicAuth.user_model.available_roles.find { |r| r.value == self.role_ref }
					end
					return @role
				end

				# *************************************************************
				# Actions
				# *************************************************************

				#
				# Load override data from session
				#
				def load_from_session(session)
					if session
						self.role_ref = session["role_ref"]
						self.user_id = session["user_id"]
					else
						self.role_ref = nil
						self.user_id = nil
					end
				end

				#
				# Save override data to session
				#
				def save_to_session
					result = {}
					
					if !self.user_id.blank? && !self.role_ref.blank?
						result["user_id"] = self.user_id
						result["role_ref"] = self.role_ref
						result["changed"] = true
					
					elsif !self.user_id.blank?
						result["user_id"] = self.user_id
						self.role_ref = self.user.role
						result["role_ref"] = self.role_ref
						result["changed"] = true

					end

					return result
				end

				def clear_session
					return {}
				end

			end
		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person with single user, user has max one person associated
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Person
				module Model1 extend ActiveSupport::Concern

					included do

						# *****************************************************
						# Structure
						# *****************************************************

						has_one :user, class_name: RicUser.user_model.to_s, as: :person

					end

					def create_user(user_params = {})
						return self.user if !self.user.nil?
						
						# Check valid conditions
						return nil if self.email.blank?

						# Build user
						user_params = synchronized_params.merge(user_params)
						user_params[:email] = self.email
						if RicUser.use_static_roles
							user_params[:role] = self.person_role
						else
							user_params[:role] = RicUser.role_model.find_by(ref: self.person_role)
						end
						user = self.build_user(user_params)

						# Password
						new_password = user.regenerate_password(notification: false)
						
						# Return invalid user with error messages
						return user if !user.errors.empty?
						if !new_password
							# TODO user.errors.add(...)
							return nil
						end

						# Notification
						RicNotification.notify(["#{self.person_role}_welcome".to_sym, self, new_password], user) if !(defined?(RicNotification).nil?)
						return user
					end

					def destroy_user
						if !self.user.nil?
							self.user.destroy
						end
					end

				end
			end
		end
	end
end
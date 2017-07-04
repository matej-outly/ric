# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person with multiple users, user has max one person associated
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Person
				module Model3 extend ActiveSupport::Concern

					included do

						# *****************************************************
						# Structure
						# *****************************************************

						has_many :users, class_name: RicUser.user_model, as: :person, dependent: :destroy

					end

					def create_user(user_params = {})
					
						# Build user
						raise "Please define e-mail in user params." if user_params[:email].blank?
						user_params = synchronized_params.merge(user_params)
						if RicUser.use_static_roles
							user_params[:role] = self.person_role
						else
							user_params[:role] = RicUser.role_model.find_by(ref: self.person_role)
						end
						user = self.users.build(user_params)

						# Password
						new_password = user.regenerate_password(notification: false)
						
						# Return invalid user with error messages
						return user if !user.errors.empty?
						if !new_password
							# TODO user.errors.add(...)
							return nil
						end

						# Notification
						RicNotification.notify(["#{self.person_role}_welcome".to_sym, self, user, new_password], user) if !(defined?(RicNotification).nil?)
						return user
					end

					def destroy_user
						raise "Not supported."
					end

				end
			end
		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * (Not implemented) Person with single user, user has multiple people associated
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Person
				module Model2 extend ActiveSupport::Concern

					included do

						# *****************************************************
						# Structure
						# *****************************************************

						has_one :user_person, class_name: RicUser.user_person_model.to_s, as: :person
						has_one :user, class_name: RicUser.user_model.to_s, through: :user_person

					end

					def create_user(user_params = {})
						return self.user_person.user if !self.user_person.nil?
						
						# Check valid conditions
						return nil if self.email.blank?
						
						# User with similar e-mail may exist
						user = RicUser.user_model.find_by(email: self.email.trim)
						if !user
							
							# Build user
							user_params = synchronized_params.merge(user_params)
							user_params[:email] = self.email
							user = RicUser.user_model.new(user_params)
							
							# Password
							new_password = user.regenerate_password(notification: false)
							
							# Return invalid user with error messages
							return user if !user.errors.empty?
							if !new_password
								# TODO user.errors.add(...)
								return nil
							end

							# Roles
							if RicUser.use_static_roles
								user.roles = self.person_role
							else
								user.roles = RicUser.role_model.find_by(ref: self.person_role)
							end
							user.save

							# Build user person
							user = self.create_user_person(user_id: user.id)

							# Notification
							RicNotification.notify(["#{self.person_role}_welcome".to_sym, self, new_password], user) if !(defined?(RicNotification).nil?)
							
						else
							if RicUser.use_static_roles
								roles = user.roles.dup
								roles << self.person_role
								user.roles = roles
							else
								# TODO
								raise "To be implemented."
							end
							user.save

							# Build user person
							user = self.create_user_person(user_id: user.id)
						end

						return user
					end

					def destroy_user
						if !self.user_person.nil?

							# Remove person role
							user = RicUser.user_model.find_by(email: self.email)
							if !user.nil?
								if RicUser.use_static_roles
									roles = user.roles.dup
									roles.delete(self.person_role)
									user.roles = roles
								else
									# TODO
									raise "To be implemented."
								end
							end

							# Remove user person association
							self.user_person.destroy

						end
					end

				end
			end
		end
	end
end
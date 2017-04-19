# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person with single user, user has multiple people associated
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Model2Person extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_one :user_person, class_name: RicUser.user_person_model.to_s, as: :person
					has_one :user, class_name: RicUser.user_model.to_s, through: :user_person

				end

				def create_user(user_params = {})
					if !self.user_person.nil?
						return self.user_person.user
					end

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
						user.roles = self.person_role
						user.save

						# Build user person
						user = self.create_user_person(user_id: user.id)

						# Notification
						RicNotification.notify(["#{self.person_role}_welcome".to_sym, self, new_password], user) if !(defined?(RicNotification).nil?)
						
					else
						roles = user.roles.dup
						roles << self.person_role
						user.roles = roles
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
							roles = user.roles.dup
							roles.delete(self.person_role)
							user.roles = roles
						end

						# Remove user person association
						self.user_person.destroy

					end
				end

			end
		end
	end
end
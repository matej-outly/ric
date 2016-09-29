# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person with multiple users
# *
# * Author: Matěj Outlý
# * Date  : 6. 9. 2016
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module PersonWithMultipleUsers extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :users, class_name: RicUser.user_model, as: :person, dependent: :destroy

				end

				def person_role
					raise "Please define person role."
				end

				def create_user(user_params)
					user_params[:role] = self.person_role
					user = self.users.build(user_params)
					new_password = user.regenerate_password(notification: false)
					if new_password
						RicNotification.notify(["#{self.person_role}_welcome".to_sym, self, user, new_password], user) if !(defined?(RicNotification).nil?)
						return user
					else
						return user
					end
				end

			end
		end
	end
end
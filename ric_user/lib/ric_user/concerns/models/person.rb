# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person
# *
# * Author: Matěj Outlý
# * Date  : 6. 9. 2016
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Person extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_one :user, class_name: RicUser.user_model.to_s, as: :person

				end

				def person_role
					raise "Please define person role."
				end

				def create_user
					user = self.build_user(email: self.email, role: self.person_role)
					new_password = user.regenerate_password(notification: false)
					if new_password
						RicNotification.notify(["welcome_#{self.person_role}".to_sym, self, new_password], user) if !(defined?(RicNotification).nil?)
						return user
					else
						return nil
					end
				end

			end
		end
	end
end
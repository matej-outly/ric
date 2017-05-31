# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Omniauthable user
# *
# * Author: Matěj Outlý
# * Date  : 28. 4. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Models
			module Omniauthable extend ActiveSupport::Concern

				included do

					has_many :authentications, class_name: RicAuth.authentication_model, dependent: :destroy
					
				end

				module ClassMethods

					#
					# Create new valid user model from OmniAuth data
					#
					# To be redefined if some more complicated conditions must be met
					#
					def create_from_omniauth(auth)
						self.create(
							email: auth.info.email
						)
					end

				end

			end
		end
	end
end
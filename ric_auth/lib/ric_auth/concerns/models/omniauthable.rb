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

					

				end

			end
		end
	end
end
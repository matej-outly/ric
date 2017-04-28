# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authentication
# *
# * Author: Matěj Outlý
# * Date  : 28. 4. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Models
			module Authentication extend ActiveSupport::Concern

				included do

					belongs_to :user, class_name: RicAuth.user_model

					validates_presence_of :user_id, :provider, :uid

				end

				module ClassMethods

					

				end

			end
		end
	end
end
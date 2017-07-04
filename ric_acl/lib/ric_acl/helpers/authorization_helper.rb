# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authorization
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicAcl
	module Helpers
		module AuthorizationHelper

			def authorize(params = {})
				return RicAcl.authorize(params)
			end

			def authorize!(params = {})
				return RicAcl.authorize!(params)
			end

		end
	end
end
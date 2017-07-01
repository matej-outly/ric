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
	module Concerns
		module Authorization extend ActiveSupport::Concern

			module ClassMethods
				
				def authorize(params = {})
					return true
				end

			end

		end
	end
end
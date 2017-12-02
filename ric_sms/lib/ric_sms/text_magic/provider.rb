# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Text Magic provider
# *
# * Author: Matěj Outlý
# * Date  : 1. 12. 2017
# *
# *****************************************************************************

module RicSms
	module TextMagic
		class Provider

			def initialize(params = {})
					
			end

			def deliver(receiver, message)
				raise "Not implemented."
			end

		end
	end
end
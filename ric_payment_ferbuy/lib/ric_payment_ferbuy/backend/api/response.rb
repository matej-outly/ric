# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API response
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Api
			class Response

				# *************************************************************
				# Attributes to be defined in child classes
				# *************************************************************

				#
				# Response code
				#
				attr_accessor :code

				#
				# Constructor
				#
				def initialize(data = {})
					self.code = data["code"].to_i if data["code"]
				end

			end
		end
	end
end
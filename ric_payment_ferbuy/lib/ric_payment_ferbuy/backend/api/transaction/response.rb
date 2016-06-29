# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API response for transaction operation
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Api
			class Transaction
				class Response < RicPaymentFerbuy::Backend::Api::Response

					#
					# Transaction status
					#
					attr_accessor :status

					#
					# Constructor
					#
					def initialize(data = {})
						super(data)
						#self.status = data[:state].to_i if data[:state] # TODO
					end

				end
			end
		end
	end
end
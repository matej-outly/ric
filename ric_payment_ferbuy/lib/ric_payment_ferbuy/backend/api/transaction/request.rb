# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API request for transaction operation
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Api
			class Transaction
				class Request < RicPaymentFerbuy::Backend::Api::Request

					#
					# Create response object matching the specific request
					#
					def response_factory(data)
						return Response.new(data)
					end

					#
					# Get operation identifier - to be implemented in child classes
					#
					def operation
						return "Transaction"
					end

					#
					# Constructor
					#
					def initialize(data = {})
						self.transaction_id = data[:transaction_id] if data[:transaction_id]
						self.command = self.transaction_id
					end

				end
			end
		end
	end
end
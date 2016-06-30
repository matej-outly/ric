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
					def initialize(request, data = {})
						super(request, data)
						
						# Read status
						if  data["message"] && 
							data["message"][request.transaction_id.to_s] &&
							data["message"][request.transaction_id.to_s].length > 0 && 
							data["message"][request.transaction_id.to_s].last["status"]
							
							self.status = data["message"][request.transaction_id.to_s].last["status"].to_i
						end
					end

				end
			end
		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API request for get_payment_state operation
# *
# * Author: Matěj Outlý
# * Date  : 4. 4. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		class DataApi
			class GetPaymentState
				class Request < RicPaymentThepay::Backend::DataApi::Request

					#
					# Payment ID
					#
					attr_accessor :payment_id

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
						return "get_payment_state"
					end

					#
					# Constructor
					#
					def initialize(data = {})
						self.payment_id = data[:payment_id] if data[:payment_id]
					end

					#
					# Get all request specific data
					#
					def specific_data
						result = {}
						result["paymentId"] = self.payment_id if !self.payment_id.nil?
						return result
					end

				end
			end
		end
	end
end
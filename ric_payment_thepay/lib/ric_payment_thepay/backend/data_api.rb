# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API proxy
# *
# * Author: Matěj Outlý
# * Date  : 4. 4. 2016
# *
# *****************************************************************************

require "singleton"
require "savon"

# Common request, response and other methods
require "ric_payment_thepay/backend/data_api/request"
require "ric_payment_thepay/backend/data_api/response"
require "ric_payment_thepay/backend/data_api/signature"

# Request and response for get_payment_state operation
require "ric_payment_thepay/backend/data_api/get_payment_state/request"
require "ric_payment_thepay/backend/data_api/get_payment_state/response"

module RicPaymentThepay
	class Backend
		class DataApi
			include Singleton

			#
			# Call given request and create matching response object
			#
			def call(request)
				
				# Client
				client = Savon.client(wsdl: Config.data_web_services_wsdl)

				# Call SOAP client to form raw response
				raw_response = client.call(request.operation.to_sym, message: request.data)
				
				# Fill matching response object with raw response
				response = request.response_factory(raw_response.body["#{request.operation}_response".to_sym])

				return response
			end

			#
			# Get payment state
			#
			def get_payment_state(payment_id)
				request = GetPaymentState::Request.new(payment_id: payment_id)
				response = call(request)
				return response
			end

		end
	end
end
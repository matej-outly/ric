# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API proxy
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

require "singleton"
require "rest-client"

# Common request, response and other methods
require "ric_payment_ferbuy/backend/api/request"
require "ric_payment_ferbuy/backend/api/response"
require "ric_payment_ferbuy/backend/api/checksum"

# Request and response for transaction operation
require "ric_payment_ferbuy/backend/api/transaction/request"
require "ric_payment_ferbuy/backend/api/transaction/response"

# Request and response for mark_order_shipped operation
require "ric_payment_ferbuy/backend/api/mark_order_shipped/request"
require "ric_payment_ferbuy/backend/api/mark_order_shipped/response"

module RicPaymentFerbuy
	class Backend
		class Api
			include Singleton

			#
			# Call given request and create matching response object
			#
			def call(request)
				
				begin
					response = RestClient.post(URI.escape(Config.api_url + request.operation), request.data)
				rescue RestClient::Unauthorized, Exception
					return nil
				end

				# Check response
				if response.code != 200
					return nil
				end

				# Parse response
				parsed_response = JSON.parse(response.to_s)
				
				# Check format
				if parsed_response["api"].nil? || parsed_response["api"]["response"].nil?
					return nil
				end

				# Fill matching response object with parsed response
				response = request.response_factory(parsed_response["api"]["response"])

				return response
			end

			#
			# Get transaction info
			#
			def transaction(transaction_id)
				request = Transaction::Request.new(transaction_id: transaction_id)
				response = call(request)
				return response
			end

			#
			# Mark transaction as shipped
			#
			def mark_order_shipped(transaction_id, postal_company, tracking_number)
				request = MarkOrderShipped::Request.new(
					transaction_id: transaction_id,
					postal_company: postal_company,
					tracking_number: tracking_number
				)
				response = call(request)
				return response
			end

		end
	end
end
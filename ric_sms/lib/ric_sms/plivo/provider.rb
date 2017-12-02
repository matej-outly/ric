# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Plivo provider
# *
# * Author: Matěj Outlý
# * Date  : 1. 12. 2017
# *
# *****************************************************************************

require "plivo"

module RicSms
	module Plivo
		class Provider

			def initialize(params = {})
				if params[:auth_id].blank? || params[:auth_token].blank?
					raise "Please provide Auth ID and Auth Token in provider params."
				end
				@auth_id = params[:auth_id]
				@auth_token = params[:auth_token]
				@api = ::Plivo::RestAPI.new(@auth_id, @auth_token)
			end

			def deliver(receiver, message)
				
				# Check message length.
				if message.bytesize > 200
					raise "Message too long."
				end

				# Request API
				response = @api.send_message({
					"src" => RicSms.sender, # TOOD: This should be improved to take sender from number pool and remember number / message mapping
					"dst" => receiver.to_s,
					"text" => message.to_s,
					"method" => "POST"
				})

				return true
			end

		end
	end
end
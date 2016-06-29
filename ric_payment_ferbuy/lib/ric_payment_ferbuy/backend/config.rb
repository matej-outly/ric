# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Config proxy
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Config

			def self.env
				if RicPaymentFerbuy.environment.to_s == "production"
					return "live"
				else
					return "demo"
				end
			end

			def self.gate_url
				if RicPaymentFerbuy.environment.to_s == "production"
					result = RicPaymentFerbuy.gate_url
				else
					result = RicPaymentFerbuy.test_gate_url
				end
				result += "/" if !result.end_with?("/")
				return result
			end

			def self.api_url
				result = RicPaymentFerbuy.api_url
				result += "/" if !result.end_with?("/")
				return result
			end

			def self.site_id
				return RicPaymentFerbuy.site_id
			end

			def self.secret
				return RicPaymentFerbuy.secret
			end

			def self.default_currency
				return RicPaymentFerbuy.default_currency
			end

			def self.default_language
				return RicPaymentFerbuy.default_language
			end

		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Config proxy
# *
# * Author: Matěj Outlý
# * Date  : 8. 6. 2017
# *
# *****************************************************************************

module RicPaymentPaypal
	class Backend
		class Config

			#
			# Client ID
			#
			def self.client_id
				if RicPaymentPaypal.environment.to_s == "production"
					return RicPaymentPaypal.client_id
				else
					return RicPaymentPaypal.test_client_id
				end
			end

			#
			# Secret
			#
			def self.client_secret
				if RicPaymentPaypal.environment.to_s == "production"
					return RicPaymentPaypal.client_secret
				else
					return RicPaymentPaypal.test_client_secret
				end
			end

			#
			# PayPal mode
			#
			def self.mode
				if RicPaymentPaypal.environment.to_s == "production"
					return "live"
				else
					return "sandbox"
				end
			end

			#
			# Default currency
			#
			def self.default_currency
				return RicPaymentPaypal.default_currency
			end

		end
	end
end
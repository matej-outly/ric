# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Config proxy
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

module RicPaymentGopay
	class Backend
		class Config

			#
			# Go ID
			#
			def self.go_id
				if RicPaymentGopay.environment.to_s == "production"
					return RicPaymentGopay.go_id
				else
					return RicPaymentGopay.test_go_id
				end
			end

			#
			# Secure key
			#
			def self.secure_key
				if RicPaymentGopay.environment.to_s == "production"
					return RicPaymentGopay.secure_key
				else
					return RicPaymentGopay.test_secure_key
				end
			end

			#
			# Gateway language
			#
			def self.language
				return RicPaymentGopay.language
			end

			#
			# Allowed payment channels
			#
			def self.allowed_channels
				return RicPaymentGopay.allowed_channels
			end

			#
			# Default currency
			#
			def self.default_currency
				return RicPaymentGopay.default_currency
			end

			#
			# URL for web services communication
			#
			def self.ws_url
				if RicPaymentGopay.environment.to_s == "production"
					return PaymentConstants::GOPAY_WS_ENDPOINT
				else
					return PaymentConstants::GOPAY_WS_ENDPOINT_TEST
				end
			end

			#
			# Redirect URL
			#
			def self.redirect_url
				if RicPaymentGopay.environment.to_s == "production"
					return PaymentConstants::GOPAY_FULL
				else
					return PaymentConstants::GOPAY_FULL_TEST
				end
			end

		end
	end
end
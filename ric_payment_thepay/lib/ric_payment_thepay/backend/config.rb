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

module RicPaymentThepay
	class Backend
		class Config

			def self.gate_url
				if RicPaymentThepay.environment.to_s == "production"
					return RicPaymentThepay.gate_url
				else
					return RicPaymentThepay.test_gate_url
				end
			end

			def self.merchant_id
				if RicPaymentThepay.environment.to_s == "production"
					return RicPaymentThepay.merchant_id
				else
					return RicPaymentThepay.test_merchant_id
				end
			end

			def self.account_id
				if RicPaymentThepay.environment.to_s == "production"
					return RicPaymentThepay.account_id
				else
					return RicPaymentThepay.test_account_id
				end
			end

			def self.password
				if RicPaymentThepay.environment.to_s == "production"
					return RicPaymentThepay.password
				else
					return RicPaymentThepay.test_password
				end
			end

			def self.data_api_password
				if RicPaymentThepay.environment.to_s == "production"
					return RicPaymentThepay.data_api_password
				else
					return RicPaymentThepay.test_data_api_password
				end
			end

			def self.web_services_wsdl
				if RicPaymentThepay.environment.to_s == "production"
					return RicPaymentThepay.web_services_wsdl
				else
					return RicPaymentThepay.test_web_services_wsdl
				end
			end

			def self.data_web_services_wsdl
				if RicPaymentThepay.environment.to_s == "production"
					return RicPaymentThepay.data_web_services_wsdl
				else
					return RicPaymentThepay.test_data_web_services_wsdl
				end
			end

			def self.default_currency
				return RicPaymentThepay.default_currency
			end

		end
	end
end
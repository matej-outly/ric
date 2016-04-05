# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API response for get_payment_state operation
# *
# * Author: Matěj Outlý
# * Date  : 4. 4. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		class DataApi
			class GetPaymentState
				class Response < RicPaymentThepay::Backend::DataApi::Response

					#
					# State
					#
					attr_accessor :state

					#
					# Constructor
					#
					def initialize(data = {})
						self.state = data[:state].to_i if data[:state]
					end

				end
			end
		end
	end
end
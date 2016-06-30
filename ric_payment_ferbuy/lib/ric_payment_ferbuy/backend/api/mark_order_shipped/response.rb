# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API response for mark_order_shipped operation
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Api
			class MarkOrderShipped
				class Response < RicPaymentFerbuy::Backend::Api::Response

					#
					# Constructor
					#
					def initialize(request, data = {})
						super(request, data)
					end

				end
			end
		end
	end
end
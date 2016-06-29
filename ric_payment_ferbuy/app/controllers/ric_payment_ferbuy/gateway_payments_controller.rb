# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

require_dependency "ric_payment_ferbuy/gateway_controller"

module RicPaymentFerbuy
	class GatewayPaymentsController < GatewayController
		include RicPaymentFerbuy::Concerns::Controllers::Gateway::PaymentsController
	end
end

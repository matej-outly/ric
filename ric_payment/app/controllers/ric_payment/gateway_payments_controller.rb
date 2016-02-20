# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_payment/gateway_controller"

module RicPayment
	class GatewayPaymentsController < GatewayController
		include RicPayment::Concerns::Controllers::Gateway::PaymentsController
	end
end

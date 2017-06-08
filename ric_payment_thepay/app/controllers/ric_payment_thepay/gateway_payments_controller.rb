# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

require_dependency "ric_payment_thepay/gateway_controller"

module RicPaymentThepay
	class GatewayPaymentsController < GatewayController
		include RicPaymentThepay::Concerns::Controllers::Gateway::PaymentsController
	end
end


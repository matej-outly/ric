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

require_dependency "ric_payment_gopay/gateway_controller"

module RicPaymentGopay
	class GatewayPaymentsController < GatewayController
		include RicPaymentGopay::Concerns::Controllers::Gateway::PaymentsController
	end
end

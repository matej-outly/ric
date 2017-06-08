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

require_dependency "ric_payment_paypal/gateway_controller"

module RicPaymentPaypal
	class GatewayPaymentsController < GatewayController
		include RicPaymentPaypal::Concerns::Controllers::Gateway::PaymentsController
	end
end

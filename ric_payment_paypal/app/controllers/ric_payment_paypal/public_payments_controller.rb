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

require_dependency "ric_payment_paypal/public_controller"

module RicPaymentPaypal
	class PublicPaymentsController < PublicController
		include RicPaymentPaypal::Concerns::Controllers::Public::PaymentsController
	end
end

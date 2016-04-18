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

require_dependency "ric_payment_gopay/public_controller"

module RicPaymentGopay
	class PublicPaymentsController < PublicController
		include RicPaymentGopay::Concerns::Controllers::Public::PaymentsController
	end
end

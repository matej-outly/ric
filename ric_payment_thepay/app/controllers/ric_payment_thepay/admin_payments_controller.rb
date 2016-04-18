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

require_dependency "ric_payment_thepay/admin_controller"

module RicPaymentThepay
	class AdminPaymentsController < AdminController
		include RicPaymentThepay::Concerns::Controllers::Admin::PaymentsController
	end
end

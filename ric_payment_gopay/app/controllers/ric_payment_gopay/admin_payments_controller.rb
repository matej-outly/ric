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

require_dependency "ric_payment_gopay/admin_controller"

module RicPaymentGopay
	class AdminPaymentsController < AdminController
		include RicPaymentGopay::Concerns::Controllers::Admin::PaymentsController
	end
end


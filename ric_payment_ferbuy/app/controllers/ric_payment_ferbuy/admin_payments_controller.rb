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

require_dependency "ric_payment_ferbuy/admin_controller"

module RicPaymentFerbuy
	class AdminPaymentsController < AdminController
		include RicPaymentFerbuy::Concerns::Controllers::Admin::PaymentsController
	end
end


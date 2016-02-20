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

require_dependency "ric_payment/admin_controller"

module RicPayment
	class AdminPaymentsController < AdminController
		include RicPayment::Concerns::Controllers::Admin::PaymentsController
	end
end


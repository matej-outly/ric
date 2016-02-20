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

require_dependency "ric_payment/public_controller"

module RicPayment
	class PublicPaymentsController < PublicController
		include RicPayment::Concerns::Controllers::Public::PaymentsController
	end
end

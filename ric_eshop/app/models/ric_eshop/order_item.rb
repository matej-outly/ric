# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Order item
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	class OrderItem < ActiveRecord::Base
		include RicEshop::Concerns::Models::OrderItem
		include RicPayment::Concerns::Models::PaymentSubjectItem if defined?(RicPayment)
	end
end

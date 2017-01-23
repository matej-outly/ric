# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Order
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	class Order < ActiveRecord::Base
		include RicEshop::Concerns::Models::Order
		include RicPayment::Concerns::Models::PaymentSubject if defined?(RicPayment)
	end
end
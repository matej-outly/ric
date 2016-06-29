# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Railtie for view helpers integration
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Railtie < Rails::Railtie
		initializer "ric_payment_ferbuy.helpers" do
			ActionView::Base.send :include, Helpers::MerchantHelper
		end
	end
end
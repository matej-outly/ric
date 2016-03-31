# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Railtie for view helpers integration
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Railtie < Rails::Railtie
		initializer "ric_payment_thepay.helpers" do
			ActionView::Base.send :include, Helpers::MerchantHelper
		end
	end
end
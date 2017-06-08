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

module RicPaymentPaypal
	class Railtie < Rails::Railtie
		initializer "ric_payment_paypal.helpers" do
			ActionView::Base.send :include, Helpers::MerchantHelper
		end
	end
end
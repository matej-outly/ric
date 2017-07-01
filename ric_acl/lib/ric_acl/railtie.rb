# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Railtie for view helpers integration
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicAcl
	class Railtie < Rails::Railtie
		initializer "ric_acl.helpers" do
			ActionView::Base.send :include, Helpers::AuthorizationHelper
		end
	end
end
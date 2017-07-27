# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Railtie for view helpers integration
# *
# * Author: Matěj Outlý
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

module RicDms
	class Railtie < Rails::Railtie
		initializer "ric_dms.helpers" do
			ActionView::Base.send :include, Helpers::MimeTypeHelper
		end
	end
end
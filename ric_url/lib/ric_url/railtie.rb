# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Railtie for view helpers integration
# *
# * Author: Matěj Outlý
# * Date  : 22. 7. 2015
# *
# *****************************************************************************

module RicUrl
	class Railtie < Rails::Railtie
		initializer "ric_url.helpers" do
			ActionView::Base.send :include, Helpers::LocaleHelper
			ActionView::Base.send :include, Helpers::SlugHelper
		end
	end
end
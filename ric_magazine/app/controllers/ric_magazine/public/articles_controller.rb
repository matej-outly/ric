# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Articles
# *
# * Author: Matěj Outlý
# * Date  : 13. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_magazine/application_controller"

module RicMagazine
	class Public::ArticlesController < ApplicationController
		include RicMagazine::Concerns::Controllers::Public::ArticlesController
	end
end

# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newies
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_journal/admin_controller"

module RicJournal
	class AdminNewiesController < AdminController
		include RicJournal::Concerns::Controllers::Admin::NewiesController
	end
end


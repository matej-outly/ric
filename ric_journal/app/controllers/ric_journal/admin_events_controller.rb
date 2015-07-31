# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

require_dependency "ric_journal/admin_controller"

module RicJournal
	class AdminEventsController < AdminController
		include RicJournal::Concerns::Controllers::Admin::EventsController
	end
end

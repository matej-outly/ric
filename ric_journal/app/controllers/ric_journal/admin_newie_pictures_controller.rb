# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newie pictures
# *
# * Author: Matěj Outlý
# * Date  : 25. 8. 2015
# *
# *****************************************************************************

require_dependency "ric_journal/admin_controller"

module RicJournal
	class AdminNewiePicturesController < AdminController
		include RicJournal::Concerns::Controllers::Admin::NewiePicturesController
	end
end

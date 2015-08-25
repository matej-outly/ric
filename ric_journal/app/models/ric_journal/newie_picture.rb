# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newie picture
# *
# * Author: Matěj Outlý
# * Date  : 25. 8. 2015
# *
# *****************************************************************************

module RicJournal
	class NewiePicture < ActiveRecord::Base
		include RicJournal::Concerns::Models::NewiePicture
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newie
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicJournal
	class Newie < ActiveRecord::Base
		include RicJournal::Concerns::Models::Newie
	end
end

# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newies ticker
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

class RicJournal::NewiesTickerComponent < RugController::Component

	def control
		@newies = RicJournal.newie_model.published.order(published_at: :desc).limit(config(:limit))
	end

end
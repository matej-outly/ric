# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Partners ticker component
# *
# * Author: Matěj Outlý
# * Date  : 6. 10. 2015
# *
# *****************************************************************************

class RicPartnership::PartnersTickerComponent < RugController::Component

	def control
		@partners = RicPartnership.partner_model.all.order(position: :asc)
	end

end
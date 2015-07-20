# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Products ticker
# *
# * Author: Matěj Outlý
# * Date  : 20. 7. 2015
# *
# *****************************************************************************

class RicAssortment::ProductsTickerComponent < RugController::Component

	def control
		@products = RicAssortment.product_model.order("random()").limit(config(:limit))
	end

end
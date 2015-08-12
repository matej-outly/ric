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
		
		# Ticker object
		@product_ticker = RicAssortment.product_ticker_model.where(key: config(:key)).first

		# Products
		if @product_ticker
			@products = @product_ticker.products.order("random()").limit(config(:limit))
		else
			@products = RicAssortment.product_model.order("random()").limit(config(:limit))
		end
	end

end
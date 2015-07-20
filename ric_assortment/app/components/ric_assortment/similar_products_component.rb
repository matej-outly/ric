# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Similar products
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2015
# *
# *****************************************************************************

class RicAssortment::SimilarProductsComponent < RugController::Component

	def control
		
		# Current product and category
		current_product = RicAssortment.product_model.find_by_id(@controller.params[:id])
		current_product_category = RicAssortment.product_category_model.find_by_id(@controller.params[:product_category_id])

		# Select similar products
		@products = RicAssortment.product_model.all
		if current_product_category
			@products = @products.from_category(current_product_category.id)
		end
		if current_product
			@products = @products.where("products.id <> ?", current_product.id)
		end
		@products = @products.order("random()").limit(config(:limit))

	end

end
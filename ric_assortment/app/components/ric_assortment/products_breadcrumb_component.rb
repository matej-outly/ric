# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Products breadcrumb
# *
# * Author: Matěj Outlý
# * Date  : 20. 7. 2015
# *
# *****************************************************************************

class RicAssortment::ProductsBreadcrumbComponent < RugController::Component

	def control
		
		# Current product and category
		current_product = RicAssortment.product_model.find_by_id(@controller.params[:id])
		current_product_category = RicAssortment.product_category_model.find_by_id(@controller.params[:product_category_id])

		# Get all items
		@items = []
		if current_product_category
			current_product_category.self_and_ancestors.each do |product_category|
				@items << OpenStruct.new( 
					label: product_category.name, 
					url: @controller.ric_assortment_public.products_path(product_category_id: product_category.id) 
				)
			end
		end
		if current_product
			@items << OpenStruct.new( 
				label: current_product.name, 
				url: @controller.ric_assortment_public.product_path(id: current_product.id, product_category_id: (current_product_category ? current_product_category.id : nil)) 
			)
		end
	end

end
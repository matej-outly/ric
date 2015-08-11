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

		# Items preset
		@items = []

		# Get all prepended items
		prepend = config(:prepend)
		if prepend
			prepend.each do |prepended_item|
				url = prepended_item[:url]
				url = "#" if url.blank?
				@items << OpenStruct.new( 
					label: I18n.t(prepended_item[:label], default: prepended_item[:label]), 
					url: url
				)
			end
		end

		# Get all dynamic items		
		if current_product_category
			current_product_category.self_and_ancestors.each do |product_category|
				url = @controller.ric_assortment_public.from_category_products_path(product_category_id: product_category.id) 
				url = "#" if url.blank?
				@items << OpenStruct.new( 
					label: product_category.name, 
					url: url
				)
			end
		end
		if current_product
			url = @controller.ric_assortment_public.product_path(id: current_product.id, product_category_id: (current_product_category ? current_product_category.id : nil)) 
			url = "#" if url.blank?
			@items << OpenStruct.new( 
				label: current_product.name, 
				url: url
			)
		end
	end

end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Breadcrumb component
# *
# * Author: Matěj Outlý
# * Date  : 4. 8. 2015
# *
# *****************************************************************************

class RicWebsite::BreadcrumbComponent < RugController::Component

	def control

		# Page model classes
		page_model = RicWebsite.page_model

		# Select all items
		if page_model.hierarchically_ordered?
			all_items = page_model.order(lft: :asc)
		elsif page_model.ordered?
			all_items = page_model.order(position: :asc)
		else
			all_items = page_model.order(id: :asc)
		end

		# Find active item and path
		active_path = [nil]
		active_item = nil
		all_items.each do |item|

			# Construct path
			if item.parent_id != active_path.last
				# We are on a new level, did we descend or ascend?
				if active_path.include?(item.parent_id)
					# Remove the wrong trailing path elements
					while active_path.last != item.parent_id
						active_path.pop
					end
				else
					active_path << item.parent_id
				end
			end

			# Break if active found
			if item.active_url?(controller.request)
				active_item = item
				break
			end
		end

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
		active_path.each do |item|
			if item
				url = item.url
				url = "#" if url.blank?
				@items << OpenStruct.new( 
					label: item.title,
					url: url
				)
			end
		end
		if active_item
			url = active_item.url
			url = "#" if url.blank?
			@items << OpenStruct.new( 
				label: active_item.title,
				url: url
			)
		end

	end

end

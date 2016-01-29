# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sidemenu component
# *
# * Author: Matěj Outlý
# * Date  : 4. 8. 2015
# *
# *****************************************************************************

class RicWebsite::SidemenuComponent < RugController::Component

	def control

		# Page model classes
		page_model = RicWebsite.menu_model.reflect_on_association(:pages).class_name.constantize

		# Menu object
		menu = RicWebsite.menu_model.where(key: config(:key)).first

		# Select all items
		if page_model.hierarchically_ordered?
			all_items = menu.pages.where("depth <= :maximal_level", maximal_level: config(:maximal_level)).order(lft: :asc)
		elsif page_model.ordered?
			all_items = menu.pages.order(position: :asc)
		else
			all_items = menu.pages.order(id: :asc)
		end

		# Find active item and path
		active_path = [nil]
		active_item = nil
		path = [nil]
		all_items.each do |item|
			
			# Construct path
			if item.parent_id != path.last
				# We are on a new level, did we descend or ascend?
				if path.include?(item.parent_id)
					# Remove the wrong trailing path elements
					while path.last != item.parent_id
						path.pop
					end
				else
					path << item.parent_id
				end
			end

			# Break if active found
			if item.active_url?(controller.request)
				active_item = item
				active_path = path.dup
			end
		end

		# Find root id
		if active_item.nil? || active_path.length < config.minimal_level
			# Nothing
			root_id = nil
		elsif active_path.length == config.minimal_level
			root_id = active_item.id
		else
			root_id = active_path[config.minimal_level]
		end

		# Select root descendants
		@items = []
		if root_id
			root_lft = nil
			root_rgt = nil
			all_items.each do |item|
				if item.id == root_id
					root_lft = item.lft
					root_rgt = item.rgt
				end
				if root_lft && item.lft > root_lft
					if root_rgt && item.rgt < root_rgt
						@items << item
					end
				end
			end
		end

	end

end
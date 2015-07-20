# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Menu component
# *
# * Author: Matěj Outlý
# * Date  : 20. 7. 2015
# *
# *****************************************************************************

class RicWebsite::MenuComponent < RugController::Component

	def control
		
		# Menu and page model classes
		page_model = RicWebsite.menu_model.reflect_on_association(:pages).class_name.constantize

		# Menu object
		menu = RicWebsite.menu_model.where(key: config(:key)).first

		# Menu items
		if page_model.hierarchically_ordered?
			@items = menu.pages.where("depth <= :maximal_level", maximal_level: config(:maximal_level)).order(lft: :asc)
		elsif page_model.ordered?
			@items = menu.pages.order(position: :asc)
		else
			@items = menu.pages.order(id: :asc)
		end
	end

end
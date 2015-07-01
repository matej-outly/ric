# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product categories submenu
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2015
# *
# *****************************************************************************

class RicAssortment::ProductCategoriesSubmenuComponent < RugController::Component

	def control
		@product_categories = RicAssortment.product_category_model.all.order(lft: :asc)
	end

end
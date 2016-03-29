# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page helper
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

module RicWebsite
	module Helpers
		module PageHelper

			def self.page_get(key)

				# Find model
				page = RicWebsite.page_model.find_by_key(key)

				# Return value
				if page
					return page
				else
					return nil
				end
			end

			def page_get(key)
				return PageHelper.page_get(key)
			end

		end
	end
end
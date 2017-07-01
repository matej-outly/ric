# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * URL helper
# *
# * Author: Matěj Outlý
# * Date  : 22. 7. 2015
# *
# *****************************************************************************

module RicUrl
	module Helpers
		module UrlHelper

			def localify(path)
				return RicUrl.localify(path)
			end

			def slugify(path)
				return RicUrl.slugify(path)
			end

		end
	end
end

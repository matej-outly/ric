# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Slug
# *
# * Author: Matěj Outlý
# * Date  : 21. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	class Slug < ActiveRecord::Base
		include RicWebsite::Concerns::Models::Slug
	end
end

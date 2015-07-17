# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicWebsite
	class Page < ActiveRecord::Base
		include RicWebsite::Concerns::Models::Page
	end
end

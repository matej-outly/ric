# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Banner
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	class Banner < ActiveRecord::Base
		include RicAdvert::Concerns::Models::Banner
	end
end

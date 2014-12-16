# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Banner statistic
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	class BannerStatistic < ActiveRecord::Base
		include RicAdvert::Concerns::Models::BannerStatistic
	end
end

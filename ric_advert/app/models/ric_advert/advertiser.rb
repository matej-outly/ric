# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Advertiser
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	class Advertiser < ActiveRecord::Base
		include RicAdvert::Concerns::Models::Advertiser
	end
end

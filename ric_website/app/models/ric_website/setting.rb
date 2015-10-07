# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Setting
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

module RicWebsite
	class Setting < ActiveRecord::Base
		include RicWebsite::Concerns::Models::Setting
	end
end


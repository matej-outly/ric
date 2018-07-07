# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Override
# *
# * Author: Matěj Outlý
# * Date  : 1. 8. 2017
# *
# *****************************************************************************

module RicAuth
	class Override
		include ActiveModel::Model
		include RicAuth::Concerns::Models::OverrideUser
	end
end

# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authentication
# *
# * Author: Matěj Outlý
# * Date  : 28. 4. 2017
# *
# *****************************************************************************

module RicAuth
	class Authentication < ActiveRecord::Base
		include RicAuth::Concerns::Models::Authentication
	end
end

# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Partners
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_partnership/admin_controller"

module RicPartnership
	class AdminPartnersController < AdminController
		include RicPartnership::Concerns::Controllers::Admin::PartnersController
	end
end


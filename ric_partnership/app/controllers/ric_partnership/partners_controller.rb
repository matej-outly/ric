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

require_dependency "ric_partnership/application_controller"

module RicPartnership
	class PartnersController < ApplicationController
		include RicPartnership::Concerns::Controllers::PartnersController
	end
end


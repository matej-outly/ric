# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Seasons
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

require_dependency "ric_season/application_controller"

module RicSeason
	class SeasonsController < ApplicationController
		include RicSeason::Concerns::Controllers::SeasonsController
	end
end


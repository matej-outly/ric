# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Dashboard
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_board/application_controller"

module RicBoard
	class BoardTicketsController < ApplicationController
		include RicBoard::Concerns::Controllers::BoardTicketsController
	end
end
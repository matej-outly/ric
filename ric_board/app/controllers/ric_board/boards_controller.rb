# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Boards
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_board/application_controller"

module RicBoard
	class BoardsController < ApplicationController
		include RicBoard::Concerns::Controllers::BoardsController
	end
end
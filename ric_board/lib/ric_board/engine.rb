# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

module RicBoard
	class Engine < ::Rails::Engine

		#
		# Controllers
		#
		require "ric_board/concerns/controllers/board_tickets_controller"
		require "ric_board/concerns/controllers/boards_controller"

		isolate_namespace RicBoard

	end
end

# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Abstract engine controller
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicBoard
	class ApplicationController < ::ApplicationController

		#
		# Override this method in application
		#
		def follow_board_ticket_path(board_ticket)
			return nil
		end

	end
end
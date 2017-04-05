# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendar
# *
# * Author: Jaroslav Mlejnek
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicBoard
	class BoardTicket < ActiveRecord::Base
		include RicBoard::Concerns::Models::BoardTicket
	end
end
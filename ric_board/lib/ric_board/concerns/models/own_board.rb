# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendar
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicBoard
	module Concerns
		module Models
			module OwnBoard extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :board_tickets, as: :owner, class_name: RicBoard.board_tickets_model.to_s,  dependent: :destroy

				end

			end
		end
	end
end
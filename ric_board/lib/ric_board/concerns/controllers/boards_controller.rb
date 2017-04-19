# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Boards controller
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 9. 4. 2017
# *
# *****************************************************************************

module RicBoard
	module Concerns
		module Controllers
			module BoardsController extend ActiveSupport::Concern
				
				included do

					before_action :set_owner
					helper_method :follow_board_ticket_path
			
				end

				def show

					# All board tickets select logic is performed in helper 
					# board. This stuff can't be here in order to provide 
					# ability to include board tickets in different actions

				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				#
				# Set owner based on configuration, or it can be overriden 
				# in application to use custom owner resolve algorithm
				#
				def set_owner
					if RicBoard.use_person
						@owner = current_user.person
					else
						@owner = current_user
					end
				end

			end
		end
	end
end
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

					# Get active tickets
					board_tickets = RicBoard.board_ticket_model.active.owned_by(@owner)

					# Group them by subject type
					if RicBoard.group_board_tickets == true
						
						# Sort by group attribute and by date
						board_tickets = board_tickets.order(key: :asc).order("date ASC NULLS FIRST")

						# Load configuration options from each subject type
						@grouped = []
						board_tickets.group_by(&:key).each do |key, board_tickets|
							@grouped << [RicBoard.board_ticket_type(key), board_tickets]
						end

						# Sort dashboard by priority DESC
						@grouped.sort! { |bt1, bt2| bt2[0][:priority] <=> bt1[0][:priority] }

					else
						
						# Sort by date
						board_tickets = board_tickets.order("date ASC NULLS FIRST")
						
						# Get data for view
						@board_tickets = []
						board_tickets.each do |board_ticket|
							@board_tickets << [RicBoard.board_ticket_type(board_ticket.key), board_ticket]
						end
					end
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
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Board helper
# *
# * Author: Matěj Outlý
# * Date  : 19. 4. 2017
# *
# *****************************************************************************

module RicBoard
	module Helpers
		module BoardHelper

			#
			# Get current board tickets owned by specified owner grouped or 
			# not grouped according to configuration
			#
			def board(owner)
				
				# Get active tickets
				board_tickets = RicBoard.board_ticket_model.active.owned_by(owner)

				# Group them by subject type
				if RicBoard.group_board_tickets == true
					
					# Sort by group attribute and by date
					board_tickets = board_tickets.order(key: :asc).order("date ASC NULLS FIRST")

					# Load configuration options from each subject type
					grouped_result = []
					board_tickets.group_by(&:key).each do |key, board_tickets|
						grouped_result << [RicBoard.board_ticket_type(key), board_tickets]
					end

					# Sort dashboard by priority DESC
					grouped_result.sort! { |bt1, bt2| bt2[0][:priority] <=> bt1[0][:priority] }

					return grouped_result
				else
					
					# Sort by date
					board_tickets = board_tickets.order("date ASC NULLS FIRST")
					
					# Get data for view
					result = []
					board_tickets.each do |board_ticket|
						result << [RicBoard.board_ticket_type(board_ticket.key), board_ticket]
					end

					return result
				end

			end

		end
	end
end
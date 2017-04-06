# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Documents
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicBoard
	module Concerns
		module Controllers
			module BoardTicketsController extend ActiveSupport::Concern

				included do

					before_action :set_board_ticket, only: [:close]

				end

				#
				# Show dashboard
				#
				def index
					# Get active tickets
					board_tickets = RicBoard.board_ticket_model.active_for_owner(current_user)

					# Group them by subject type
					@board_tickets_by_subject_type = board_tickets.group_by &:subject_type
				end

				#
				# Close board ticket
				#
				def close
					@board_ticket.closed = true
					render json: @board_ticket.save
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_board_ticket
					@board_ticket = RicBoard.board_ticket_model.find_by_id(params[:id])
					if @board_ticket.nil?
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicBoard.board_ticket_model.model_name.i18n_key}.not_found")
					end
				end

			end
		end
	end
end
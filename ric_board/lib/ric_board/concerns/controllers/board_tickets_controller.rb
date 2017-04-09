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
				# TODO: Add some owner security checks

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
					if RicBoard.group_board_tickets == true
						# Load configuration options from each subject type
						@grouped = []
						board_tickets.group_by(&:subject_type).each do |subject_type, board_tickets|
							@grouped << [RicBoard.board_ticket_type(subject_type), board_tickets]
						end

						# Sort dash board by priority DESC
						@grouped.sort! { |bt1, bt2| bt2[0][:priority] <=> bt1[0][:priority] }

					else
						@board_tickets = []
						board_tickets.each do |board_ticket|
							@board_tickets << [RicBoard.board_ticket_type(board_ticket.subject_type), board_ticket]
						end
					end
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
					if @board_ticket.nil? || @board_ticket.owner != current_user
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicBoard.board_ticket_model.model_name.i18n_key}.not_found")
					end
				end

			end
		end
	end
end
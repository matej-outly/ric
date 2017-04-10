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

					before_action :set_owner
					before_action :set_board_ticket, only: [:close]

				end

				#
				# Show dashboard
				#
				def index

					# Get active tickets
					board_tickets = RicBoard.board_ticket_model.active.owned_by(@owner)

					# Group them by subject type
					if RicBoard.group_board_tickets == true
						
						# Sort by group attribute and by date
						board_tickets = board_tickets.order(subject_type: :asc).order("date ASC NULLS FIRST")

						# Load configuration options from each subject type
						@grouped = []
						board_tickets.group_by(&:subject_type).each do |subject_type, board_tickets|
							@grouped << [RicBoard.board_ticket_type(subject_type), board_tickets]
						end

						# Sort dashboard by priority DESC
						@grouped.sort! { |bt1, bt2| bt2[0][:priority] <=> bt1[0][:priority] }

					else
						
						# Sort by date
						board_tickets = board_tickets.order("date ASC NULLS FIRST")
						
						# Get data for view
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

				#
				# Set owner based on configuration, or it can be overriden 
				# in application to use custom owner resolve algorithm
				#
				def set_owner
					if RicBoard.use_person_as_owner
						@owner = current_user.person
					else
						@owner = current_user
					end
				end

				def set_board_ticket
					@board_ticket = RicBoard.board_ticket_model.find_by_id(params[:id])
					if @board_ticket.nil? || @board_ticket.owner != @owner
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicBoard.board_ticket_model.model_name.i18n_key}.not_found")
					end
				end

			end
		end
	end
end
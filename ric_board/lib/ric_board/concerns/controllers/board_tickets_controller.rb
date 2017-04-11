# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Board tickets controller
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 9. 4. 2017
# *
# *****************************************************************************

module RicBoard
	module Concerns
		module Controllers
			module BoardTicketsController extend ActiveSupport::Concern
				
				included do

					before_action :set_owner
					before_action :set_board_ticket, only: [:follow, :close]

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

				#
				# Close board ticket
				#
				def close
					@board_ticket.closed = true
					render json: @board_ticket.save
				end

				#
				# Redirect to ticket subject according to current user role
				#
				def follow
					path = follow_board_ticket_path(@board_ticket) if self.respond_to?(:follow_board_ticket_path)
					if path.nil?
						raise "Please define follow_board_ticket_path in RicBoard::ApplicationController."
					end
					redirect_to path
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

				def set_board_ticket
					@board_ticket = RicBoard.board_ticket_model.find_by_id(params[:id])
					if @board_ticket.nil? || @board_ticket.owner != @owner
						redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicBoard.board_ticket_model.model_name.i18n_key}.not_found")
					end
				end

			end
		end
	end
end
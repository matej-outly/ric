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
					before_action :set_board_ticket, only: [:close]

				end

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
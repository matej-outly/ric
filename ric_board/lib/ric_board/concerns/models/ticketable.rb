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
			module Ticketable extend ActiveSupport::Concern

				# Ideas TODO:
				# - Mergeable ... there will be only one valid ticket for given object.
				#                 Now, each crate/update action can create new board ticket,
				#                 which can spam users.
				#
				# - Destroyable ... make a ticket about destruction of object (ie. event has been cancelled...)

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :board_tickets, as: :subject, class_name: RicBoard.board_ticket_model.to_s, dependent: :destroy
					enum_column :occasion, [:create, :update]


					# *********************************************************
					# Callbacks
					# *********************************************************

					after_find :save_owner_after_find
					after_create :create_board_ticket_after_create
					after_update :create_board_ticket_after_update

				end

				#
				# Create board ticket for object creation (method can be overriden)
				#
				# Returns hash:
				# {
				#     date: self.some_date_field, # Nil for closable tickets or Date object
				#     owner: self.some_owner,
				#     create: false, # Optional for disabling creating ticket for create action
				#     update: false, # Optional for disabling creating ticket for update action
				# }
				#
				def board_ticket_params
					raise "Board ticket params must be implemented"
				end

			protected

				def save_owner_after_find
					@owner_was = board_ticket_params[:owner]
				end

				def create_board_ticket_after_create
					create_board_ticket(:create)
				end

				def create_board_ticket_after_update
					create_board_ticket(:update)
				end

				def board_ticket_params_for_occasion(occasion)
					if !board_ticket_params.include?(occasion) || board_ticket_params[occasion] == true
						if !board_ticket_params.include?(:owner)
							raise "Board ticket `owner` must be set in board ticket params"
						end

						return {
							date: (board_ticket_params.include?(:date) ? board_ticket_params[:date] : nil),
							owner: board_ticket_params[:owner],
						}

					else
						return false
					end
				end

				def create_board_ticket(occasion)
					params_for_occasion = board_ticket_params_for_occasion(occasion)
					if params_for_occasion == false
						# Board ticket is disabled for this occasion
						return
					end

					# Check if owner of the ticket is changed
					# If so, destroy old ticket
					if params_for_occasion[:owner] != @owner_was
						old_board_ticket = RicBoard.board_ticket_model.find_by(subject: self, owner: @owner_was)
						old_board_ticket.destroy unless old_board_ticket.nil?
					end

					# Create or update board ticket
					unless params_for_occasion[:owner].nil?
						board_ticket = RicBoard.board_ticket_model.find_or_initialize_by(subject: self, owner: params_for_occasion[:owner])
						board_ticket.date = params_for_occasion[:date]
						board_ticket.occasion = occasion
						board_ticket.closed = false
						board_ticket.save
					end
				end

			end
		end
	end
end
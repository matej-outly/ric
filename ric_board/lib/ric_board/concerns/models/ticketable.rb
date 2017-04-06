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
			module Boardable extend ActiveSupport::Concern

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

					has_many :board_tickets, as: :subject, class_name: RicBoard.board_tickets_model.to_s,  dependent: :destroy


					# *********************************************************
					# Callbacks
					# *********************************************************

					after_create :create_board_ticket_after_create
					after_update :create_board_ticket_after_update

				end

				#
				# Create board ticket for object creation (method can be overriden)
				#
				# Returns:
				# nil    ... create ticket about object creation, which is closable
				# Date   ... create ticket about object creation, which is active until given date
				# false  ... do not create ticket about object creation
				#
				def create_board_ticket
					return nil
				end

				#
				# Create board ticket for object update (method can be overriden)
				#
				# Returns:
				# nil    ... create ticket about object update, which is closable
				# Date   ... create ticket about object update, which is active until given date
				# false  ... do not create ticket about object update
				#
				def update_board_ticket
					return create_board_ticket
				end

			protected

				def create_board_ticket_after_create
					_create_board_ticket(create_board_ticket)
				end

				def create_board_ticket_after_update
					_create_board_ticket(update_board_ticket)
				end

				def _create_board_ticket(ticket_type)
					if ticket_type != false
						# Create board ticket
						board_ticket = self.board_tickets.build

						# TODO: Somehow fill owner!!!
						board_ticket.owner = board_ticket_owner

						if ticket_type == nil
							# Closable ticket
							board_ticket.closed = false
							board_ticket.date = nil

						else
							# Ticket with Date
							board_ticket.closed = false
							board_ticket.date = ticket_type # Implicit conversion to Date by rails, TODO: Some checks?
						end

						board_ticket.save
					end
				end

			end
		end
	end
end
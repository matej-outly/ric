# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Model is ticketable - it can own and create some board tickets
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 9. 4. 2017
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

					# *********************************************************
					# Callbacks
					# *********************************************************

					after_initialize :initialize_owner_was
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
				#     create: false, # Possible to disable create action
				#     update: false, # Possible to disable update action
				#     destroy: false, # Possible to disable destroy action
				#     key: "...", # Optional if key can't be derived from subject class name
				# }
				#
				def board_ticket_params
					raise "Board ticket params must be implemented."
				end

			protected

				def initialize_owner_was
					@owner_was = [] if @owner_was.nil?
				end

				def save_owner_after_find
					
					# Get current owner
					@owner_was = board_ticket_params[:owner] if !board_ticket_params.blank?

					# Convert owner into array
					if @owner_was.nil?
						@owner_was = []
					elsif !@owner_was.is_a?(Array)
						@owner_was = [@owner_was]
					end

				end

				def create_board_ticket_after_create
					create_board_ticket(:create)
				end

				def create_board_ticket_after_update
					create_board_ticket(:update)
				end

				def prepare_board_ticket_params(occasion)
					params = board_ticket_params

					# Disable ticket creating if params blank
					return false if params.blank?

					# Disable ticket creating if occasion disabled
					return false if params.include?(occasion) && params[occasion] != true

					if !params.include?(:owner)
						raise "Board ticket `owner` must be set in board ticket params."
					end

					# Convert owner into array
					owner = params[:owner]
					if owner.nil?
						owner = []
					elsif !owner.is_a?(Array)
						owner = [owner]
					end

					return {
						date: (params.include?(:date) ? params[:date] : nil),
						owner: owner,
						key: (params[:key].blank? ? self.class.to_s.gsub("::", "_").underscore.pluralize : params[:key]), # Either derived from class name or custom defined key
					}
				end

				def create_board_ticket(occasion)
					params = prepare_board_ticket_params(occasion)
					if params == false
						# Board ticket is disabled for this occasion
						return
					end

					# Check if owner of the ticket is changed. If so, destroy old ticket.
					@owner_was.diff(params[:owner]) do |action, owner|
						if action == :remove
							old_board_ticket = RicBoard.board_ticket_model.find_by(subject: self, owner: owner)
							old_board_ticket.destroy unless old_board_ticket.nil?
						else # add or equal
							# Create or update board ticket
							board_ticket = RicBoard.board_ticket_model.find_or_initialize_by(subject: self, owner: owner)
							board_ticket.date = params[:date]
							board_ticket.key = params[:key]
							board_ticket.occasion = occasion
							board_ticket.closed = false
							board_ticket.save
						end
					end
				end

			end
		end
	end
end
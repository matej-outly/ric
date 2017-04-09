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
			module BoardTicket extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					# belongs_to :resource, polymorphic: true
					# has_many :events, class_name: RicBoard.event_model.to_s, dependent: :destroy

					belongs_to :subject, polymorphic: true
					belongs_to :owner, polymorphic: true

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						return []
					end

					# *********************************************************
					# Queries
					# *********************************************************

					#
					# Get all active tickets for given owner
					#
					def active_for_owner(owner)
						# Get active tickets
						query = where(owner: owner).where(closed: false).where("date IS NULL OR :date <= date", date: Date.today)

						# If groupping is enabled, sort them by group attribute
						if RicBoard.group_board_tickets == true
							query = query.order(subject_type: :asc)
						end

						# Order tickets
						query = query.order("date ASC NULLS FIRST")

						return query
					end

				end

				#
				# Check if ticket is closable
				#
				def is_closable?
					self.date.nil?
				end

				#
				# Get configuration for given subject type
				#
				def board_ticket_type
					key = self.subject_type.underscore.pluralize
					if RicBoard.board_ticket_types.include?(key)
						return RicBoard.board_ticket_types[key]
					else
						raise "Key `#{key}` not found in RicBoard.board_ticket_types configuration"
					end
				end

			end
		end
	end
end
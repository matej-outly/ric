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
					# Scopes
					# *********************************************************

					def active
						where(closed: false).where("date IS NULL OR :date <= date", date: Date.today)
					end

					def owned_by(owner)
						where(owner: owner)
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
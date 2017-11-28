# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Board ticket model
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 9. 4. 2017
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

					belongs_to :subject, polymorphic: true
					belongs_to :owner, polymorphic: true

					# *********************************************************
					# Occasion
					# *********************************************************

					enum_column :occasion, [:create, :update]

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :owner_id, :owner_type, :subject_id, :subject_type, :key

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

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
					if RicBoard.board_ticket_types.include?(self.key.to_sym)
						return RicBoard.board_ticket_types[self.key.to_sym]
					else
						raise "Key `#{key}` not found in RicBoard.board_ticket_types configuration."
					end
				end

			end
		end
	end
end
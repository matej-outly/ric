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
						# Bez data jako prvni
						where(owner: owner).where(closed: false).where("date IS NULL OR :date <= date", date: Date.today).order(subject_type: :asc, date: :asc)
					end

				end

				#
				# Check if ticket is closable
				#
				def is_closable?
					self.date.nil?
				end

			end
		end
	end
end
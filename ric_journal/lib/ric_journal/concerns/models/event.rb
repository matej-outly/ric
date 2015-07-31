# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

module RicJournal
	module Concerns
		module Models
			module Event extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************
	
				end

				module ClassMethods

					# *********************************************************************
					# Scopes
					# *********************************************************************

					def held(date_from, date_to)
						where("held_at >= :date_from AND held_at < :date_to", date_from: date_from, date_to: date_to)
					end
					
				end

			end
		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newie
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicJournal
	module Concerns
		module Models
			module Newie extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************
					
					#
					# Relation to newie pictures
					#
					has_many :newie_pictures, dependent: :destroy, class_name: RicJournal.newie_picture_model.to_s

				end

				module ClassMethods

					# *********************************************************************
					# Scopes
					# *********************************************************************

					def published
						where("published_at IS NOT NULL").where("published_at < :now", now: Time.current)
					end
					
				end

			end
		end
	end
end
# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node picture
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module NodePicture extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :node, class_name: RicWebsite.node_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :node_id
					
				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************
					
					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						
					end

				end

			end
		end
	end
end
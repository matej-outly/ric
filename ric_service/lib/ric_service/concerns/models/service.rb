# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Service
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicService
	module Concerns
		module Models
			module Service extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					enable_ordering

					# *********************************************************
					# Icon
					# *********************************************************

					enum_column :icon, config(:icons)

				end

				module ClassMethods

					#
					# Columns
					#
					def permitted_columns
						result = [
							:name, 
							:description, 
							:icon
						]
						return result
					end

				end

			end
		end
	end
end
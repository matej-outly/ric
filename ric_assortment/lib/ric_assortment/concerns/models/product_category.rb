# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product category
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductCategory extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

				end

			end
		end
	end
end
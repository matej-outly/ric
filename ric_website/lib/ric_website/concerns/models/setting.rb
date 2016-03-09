# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Setting
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Setting extend ActiveSupport::Concern

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
					# Ordering
					#
					enable_ordering
					
					# *************************************************************************
					# Enums
					# *************************************************************************

					#
					# Kind
					#
					enum_column :kind, [ "string", "integer", "enum" ]

					# *************************************************************************
					# Validators
					# *************************************************************************

					#
					# Key must be present
					#
					validates_presence_of :key

				end

				module ClassMethods

				end

			end
		end
	end
end
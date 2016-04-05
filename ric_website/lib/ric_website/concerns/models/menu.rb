# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Menu
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Menu extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to pages
					#
					has_and_belongs_to_many :pages, class_name: RicWebsite.page_model.to_s
					
					# *********************************************************
					# Key
					# *********************************************************

					#
					# Key enum
					#
					enum_column :key, config(:keys)

				end

			end
		end
	end
end
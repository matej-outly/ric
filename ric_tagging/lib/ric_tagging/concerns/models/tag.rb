# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Tag
# *
# * Author: Matěj Outlý
# * Date  : 28. 12. 2017
# *
# *****************************************************************************

module RicTagging
	module Concerns
		module Models
			module Tag extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Color
					# *********************************************************

					enum_column :color, [
						:yellow, 
						:turquoise, 
						:blue, 
						:pink, 
						:purple, 
						:orange, 
						:red, 
						:green, 
						:grey
					]

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :name

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							where("
								(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))
							", query: query.to_s)
						end
					end

					# *********************************************************
					# Columns
					# *********************************************************
					
					def permitted_columns
						[
							:name,
							:color,
						]
					end

				end
			
			end
		end
	end
end
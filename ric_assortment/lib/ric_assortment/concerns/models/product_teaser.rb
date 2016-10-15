# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product teaser
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductTeaser extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					has_and_belongs_to_many :products, class_name: RicAssortment.product_model.to_s

					# *********************************************************
					# Keys
					# *********************************************************

					enum_column :key, config(:keys)

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							if config(:disable_unaccent) == true
								where_string = "(lower(name) LIKE ('%' || lower(trim(:query)) || '%'))"
							else
								where_string = "(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))"
							end
							where(where_string, query: query)
						end
					end

				end
				
			end
		end
	end
end
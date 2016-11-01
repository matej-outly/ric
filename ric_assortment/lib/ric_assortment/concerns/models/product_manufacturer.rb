# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product manufacturer
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductManufacturer extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					has_many :products, class_name: RicAssortment.product_model.to_s

					# *********************************************************
					# Logo
					# *********************************************************

					has_attached_file :logo, :styles => { thumb: config(:logo_crop, :thumb), full: config(:logo_crop, :full) }
					validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

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

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						[
							:name, 
							:url,
							:logo,
						]
					end

				end
				
			end
		end
	end
end
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
					
					# *********************************************************
					# Structure
					# *********************************************************

					has_and_belongs_to_many :products, class_name: RicAssortment.product_model.to_s

					# *********************************************************
					# Ordering
					# *********************************************************

					enable_hierarchical_ordering
					
					# *********************************************************
					# Default attributes
					# *********************************************************

					array_column :default_attributes

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						[
							:name, 
							:parent_id,
							:default_attributes,
						]
					end

					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							if config(:disable_unaccent) == true
								where_string = "(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))"
							else
								where_string = "(lower(name) LIKE ('%' || lower(trim(:query)) || '%'))"
							end
							where(where_string, query: query)
						end
					end

				end

				# *************************************************************
				# Name with depth
				# *************************************************************

				def name_with_depth(delimiter = " - ")
					return (delimiter * self.depth.to_i) + self.name.to_s
				end

			protected

				# *************************************************************
				# Slugs
				# *************************************************************

				def _url_original
					"/product_categories/#{self.id}"
				end

				def _compose_slug_translation(locale)
					# TODO ...
				end

				def _generate_slug(slug_model, locale)
					filter, translation = compose_slug_translation(locale)
					if !translation.blank?
						slug_model.add_slug(locale, URI.parse(self.url_original).path, translation, filter) 
					else
						slug_model.remove_slug(locale, URI.parse(self.url_original).path)
					end
					# TODO regenerate slug of contained products
				end

				def _destroy_slug(slug_model, locale)
					slug_model.remove_slug(locale, URI.parse(self.url_original).path)
				end

				def _destroy_slug_was(slug_model, locale)
					# original URL did not change since it is derived from ID
				end

			end
		end
	end
end
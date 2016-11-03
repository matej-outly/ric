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
					# Slugs
					# *********************************************************

					after_save :generate_slugs

					before_destroy :destroy_slugs, prepend: true

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
				# Slugs
				# *************************************************************

				#
				# Genereate slugs after save
				#
				def generate_slugs(options = {})
					
					# Generate slug in this model
					if config(:enable_slugs) == true && !RicUrl.slug_model.nil?
						url = config(:url).gsub(/:id/, self.id.to_s)
						tmp_uri = URI.parse(url)
						I18n.available_locales.each do |locale|
							translation = RicUrl.slug_model.compose_translation(locale, models: self.self_and_ancestors, label: :name, is_category: true)
							RicUrl.slug_model.add_slug(locale, tmp_uri.path, translation)
						end
					end

					# Propagate to other models
					if options[:disable_propagation] != true
						
						# Propagate to descendants
						self.descendants.each do |descendant|
							descendant.generate_slugs(disable_propagation: true)
						end

					end

				end

				#
				# Destroy slugs before destroy
				#
				def destroy_slugs(options = {})

					# Destroy slug of this model
					if config(:enable_slugs) == true && !RicUrl.slug_model.nil?
						url = config(:url).gsub(/:id/, self.id.to_s)
						tmp_uri = URI.parse(url)
						I18n.available_locales.each do |locale|
							RicUrl.slug_model.remove_slug(locale, tmp_uri.path)
						end
					end

					# Propagate to other models
					if options[:disable_propagation] != true
						
						# Propagate to descendants
						self.descendants.each do |descendant|
							descendant.destroy_slugs(disable_propagation: true)
						end

					end

				end

				# *************************************************************
				# Name with depth
				# *************************************************************

				def name_with_depth(delimiter = " - ")
					return (delimiter * self.depth.to_i) + self.name.to_s
				end

			end
		end
	end
end
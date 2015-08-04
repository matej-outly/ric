# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module Product extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					#
					# Relation to product categories
					#
					has_and_belongs_to_many :product_categories, class_name: RicAssortment.product_category_model.to_s

					#
					# Relation to product attachments
					#
					has_and_belongs_to_many :product_attachments, class_name: RicAssortment.product_attachment_model.to_s

					#
					# Relation to product photos
					#
					has_many :product_photos, class_name: RicAssortment.product_photo_model.to_s, dependent: :destroy

					#
					# Ordering
					#
					enable_ordering
					
					#
					# Genereate slugs before save
					#
					before_save :generate_slugs

					#
					# Destroy slugs before destroy
					#
					before_destroy :destroy_slugs

				end

				module ClassMethods

					#
					# Parts
					#
					def parts
						[:identification, :content, :dimensions, :price, :meta]
					end
					
					# *********************************************************************
					# Scopes
					# *********************************************************************

					def from_category(product_category_id)
						if product_category_id.nil?
							all
						else
							joins(:product_categories).where(product_categories: { id: product_category_id })
						end
					end

				end

				# *************************************************************
				# Slug
				# *************************************************************

				#
				# Genereate slugs before save
				#
				def generate_slugs
					if config(:enable_slugs) == true && !RicWebsite.slug_model.nil?
						url = config(:url).gsub(/:id/, self.id.to_s)
						tmp_uri = URI.parse(url)
						I18n.available_locales.each do |locale|
							if self.respond_to?("name_#{locale.to_s}".to_sym)
								translation = self.send("name_#{locale.to_s}".to_sym)
							elsif self.respond_to?(:name)
								translation = self.name
							else
								translation = nil
							end
							if !translation.blank?
								translation = translation.to_url + ".html"
								RicWebsite.slug_model.add_slug(locale, tmp_uri.path, translation)
							end
						end
					end
				end

				#
				# Destroy slugs before destroy
				#
				def destroy_slugs
					if config(:enable_slugs) == true && !RicWebsite.slug_model.nil?
						url = config(:url).gsub(/:id/, self.id.to_s)
						tmp_uri = URI.parse(url)
						I18n.available_locales.each do |locale|
							RicWebsite.slug_model.remove_slug(locale, tmp_uri.path)
						end
					end
				end

			end
		end
	end
end
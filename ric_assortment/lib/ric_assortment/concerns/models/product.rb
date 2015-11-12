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
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to product categories
					#
					has_and_belongs_to_many :product_categories, class_name: RicAssortment.product_category_model.to_s, after_add: :update_default_product_category, after_remove: :update_default_product_category

					#
					# Relation to product categories
					#
					belongs_to :default_product_category, class_name: RicAssortment.product_category_model.to_s

					#
					# Relation to product attachments
					#
					has_and_belongs_to_many :product_attachments, class_name: RicAssortment.product_attachment_model.to_s

					#
					# Relation to product photos
					#
					has_many :product_photos, class_name: RicAssortment.product_photo_model.to_s, dependent: :destroy

					#
					# Relation to product tickers
					#
					has_and_belongs_to_many :product_tickers, class_name: RicAssortment.product_ticker_model.to_s

					# *********************************************************
					# Enums
					# *********************************************************

					#
					# Currency
					#
					enum_column :currency, config(:currencies)

					# *********************************************************
					# Ordering
					# *********************************************************

					#
					# Ordering
					#
					enable_ordering

					# *********************************************************
					# Callbacks
					# *********************************************************

					#
					# Genereate slugs after save
					#
					after_save :generate_slugs

					#
					# Destroy slugs before destroy
					#
					before_destroy :destroy_slugs, prepend: true

				end

				module ClassMethods

					#
					# Parts
					#
					def parts
						[:identification, :content, :dimensions, :price, :meta]
					end

					#
					# Columns
					#	
					def identification_part_columns
						[:name, :catalogue_number, :ean]
					end

					#
					# Columns
					#	
					def content_part_columns
						[:perex, :content]
					end

					#
					# Columns
					#
					def dimensions_part_columns
						[:height, :width, :depth, :weight]
					end

					#
					# Columns
					#
					def price_part_columns
						[:price, :unit]
					end

					#
					# Columns
					#
					def meta_part_columns
						[:description, :keywords]
					end
					
					# *********************************************************
					# Scopes
					# *********************************************************

					def from_category(product_category_id)
						if product_category_id.nil?
							all
						else
							joins(:product_categories).where(product_categories: { id: product_category_id })
						end
					end

				end

				# *************************************************************
				# Duplicate
				# *************************************************************

				def duplicate
					
					# Base duplication
					new_record = self.dup

					ActiveRecord::Base.transaction do

						# Base save
						new_record.save

						# Categories
						new_record.product_categories = self.product_categories

						# Attachments
						new_record.product_attachments = self.product_attachments

						# Tickers
						new_record.product_tickers = self.product_tickers

						# Photos
						self.product_photos.each do |product_photo|
							new_record.product_photos << product_photo.duplicate
						end

					end

					return new_record
				end

				# *************************************************************
				# Slug
				# *************************************************************

				#
				# Genereate slugs after save
				#
				def generate_slugs
					if config(:enable_slugs) == true && !RicWebsite.slug_model.nil?
						
						# Get all models relevant for slug
						slug_models = []
						slug_models.concat(self.default_product_category.self_and_ancestors) if self.default_product_category
						slug_models << self

						# Compose URL
						url = config(:url).gsub(/:id/, self.id.to_s)
						tmp_uri = URI.parse(url)
						
						I18n.available_locales.each do |locale|
							translation = RicWebsite.slug_model.compose_translation(locale, models: slug_models, label: :name)
							RicWebsite.slug_model.add_slug(locale, tmp_uri.path, translation)
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

				# *************************************************************
				# Default category
				# *************************************************************

				#
				# Find and bind default category (first of categories with maximal depth)
				#
				def associate_default_product_category
					default_product_category = self.product_categories.order(depth: :desc, lft: :asc).first
					if default_product_category
						self.default_product_category_id = default_product_category.id
					else
						self.default_product_category_id = nil
					end
					return default_product_category
				end

				#
				# Find and bind default category (first of categories with maximal depth)
				#
				def update_default_product_category(added_or_removed_product_category = nil)
					default_product_category = associate_default_product_category
					self.save
					return default_product_category
				end

			end
		end
	end
end
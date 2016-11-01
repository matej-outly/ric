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

					has_and_belongs_to_many :product_categories, class_name: RicAssortment.product_category_model.to_s, after_add: :update_default_product_category, after_remove: :update_default_product_category

					belongs_to :default_product_category, class_name: RicAssortment.product_category_model.to_s

					has_many :product_pictures, class_name: RicAssortment.product_picture_model.to_s, dependent: :destroy if RicAssortment.enable_pictures

					has_and_belongs_to_many :product_attachments, class_name: RicAssortment.product_attachment_model.to_s if RicAssortment.enable_attachments

					has_and_belongs_to_many :product_teasers, class_name: RicAssortment.product_teaser_model.to_s if RicAssortment.enable_teasers

					belongs_to :product_manufacturer, class_name: RicAssortment.product_manufacturer_model.to_s if RicAssortment.enable_manufacturers

					# *********************************************************
					# Currency
					# *********************************************************

					enum_column :currency, config(:currencies)

					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering

					# *********************************************************
					# Slugs
					# *********************************************************

					after_save :generate_slugs

					before_destroy :destroy_slugs, prepend: true

					# *********************************************************
					# Name
					# *********************************************************

					#
					# Add name with category to JSON output
					#
					add_methods_to_json :name_with_category

					# *********************************************************
					# Other attributes
					# *********************************************************

					store_accessor :other_attributes

					before_save :_synchronize_category_attributes

					# *********************************************************
					# Filter
					# *********************************************************

					attr_accessor :product_category_id # For filtering by product category

				end

				module ClassMethods

					# *********************************************************
					# Parts
					# *********************************************************

					def parts
						result = {}
						result[:identification] = [:show, :form]
						result[:attributes] = [:show, :form]
						result[:content] = [:show, :form]
						result[:pictures] = [:show] if RicAssortment.enable_pictures
						result[:pricing] = [:show, :form]
						result[:meta] = [:show, :form]
						result[:teasers] = [:show] if RicAssortment.enable_teasers
						result[:attachments] = [:show] if RicAssortment.enable_attachments
						return result
					end

					# *********************************************************
					# Columns
					# *********************************************************
					
					def permitted_columns
						[
							# Identification
							:name, 
							:catalogue_number,
							:ean,
							:product_category_ids,
							:product_manufacturer_id,

							# Attributes
							:other_attributes,
							
							# Content
							:perex, 
							:content,

							# Price part
							:price, 
							:currency,

							# Meta part
							:description,
							:keywords,
						]
					end

					def filter_columns
						[
							:name, 
							:catalogue_number,
							:ean,
							:product_category_id,
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
								where_string = "(lower(name) LIKE ('%' || lower(trim(:query)) || '%'))"
							else
								where_string = "(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))"
							end
							where(where_string, query: query)
						end
					end

					def from_category(product_category_id)
						if product_category_id.blank?
							all
						else
							joins(:product_categories).where(product_categories: { id: product_category_id })
						end
					end
					
					def filter(params = {})
						
						# Preset
						result = all

						# Name
						if !params[:name].blank?
							if config(:disable_unaccent) == true
								result = result.where("lower(products.name) LIKE ('%' || lower(trim(?)) || '%')", params[:name].to_s)
							else
								result = result.where("lower(unaccent(products.name)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:name].to_s)
							end
						end

						# Catalogue number
						if !params[:catalogue_number].blank?
							if config(:disable_unaccent) == true
								result = result.where("lower(products.catalogue_number) LIKE ('%' || lower(trim(?)) || '%')", params[:catalogue_number].to_s)
							else
								result = result.where("lower(unaccent(products.catalogue_number)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:catalogue_number].to_s)
							end
						end

						# EAN
						if !params[:ean].blank?
							if config(:disable_unaccent) == true
								result = result.where("lower(products.ean) LIKE ('%' || lower(trim(?)) || '%')", params[:ean].to_s)
							else
								result = result.where("lower(unaccent(products.ean)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:ean].to_s)
							end
						end

						# Product category
						if !params[:product_category_id].blank?
							result = result.from_category(params[:product_category_id])
						end
					
						result
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
						new_record.product_attachments = self.product_attachments if RicAssortment.enable_attachments

						# Teasers
						new_record.product_teasers = self.product_teasers if RicAssortment.enable_teasers

						# Pictures
						if RicAssortment.enable_pictures
							self.product_pictures.each do |product_picture|
								new_record.product_pictures << product_picture.duplicate
							end
						end

					end

					return new_record
				end

				# *************************************************************
				# Slugs
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

				# *************************************************************
				# Name
				# *************************************************************

				#
				# Get name with default product category name combined
				#
				def name_with_category
					result = self.name
					result += " - " + self.default_product_category.name if self.default_product_category
					return result
				end
				
				# *************************************************************
				# Attributes
				# *************************************************************

				def _synchronize_category_attributes
					self.product_categories.each do |leaf_product_category|
						leaf_product_category.self_and_ancestors.each do |product_category|
							if product_category.default_attributes
								product_category.default_attributes.each do |default_attribute|
									if self.other_attributes.nil?
										self.other_attributes = {}
									end
									if !self.other_attributes.key?(default_attribute)
										self.other_attributes[default_attribute] = ""
									end
								end
							end
						end
					end
				end

				def synchronize_category_attributes
					self._synchronize_category_attributes
					self.save
				end

			end
		end
	end
end
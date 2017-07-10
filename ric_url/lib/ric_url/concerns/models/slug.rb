# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Slug
# *
# * Author: Matěj Outlý
# * Date  : 21. 7. 2015
# *
# *****************************************************************************

module RicUrl
	module Concerns
		module Models
			module Slug extend ActiveSupport::Concern

				module ClassMethods

					#
					# Clear slug cache
					#
					# Must be done if data changed in DB
					#
					def clear_cache
						@o2t = nil
						@t2o = nil
					end

					#
					# Load specific locale to cache
					#
					def load_cache(locale)

						# Initialize cache structures
						if @o2t.nil?
							@o2t = {}
						end
						if @t2o.nil?
							@t2o = {}
						end

						# Fill cache if empty
						if @o2t[locale.to_sym].nil? || @t2o[locale.to_sym].nil?
							
							@o2t[locale.to_sym] = {}
							@t2o[locale.to_sym] = {}

							data = where(locale: locale.to_s)
							data.each do |item|
								if RicUrl.use_filter
									if RicUrl.current_app_filter.to_s == item.filter # Slug belongs to current application
										@o2t[locale.to_sym][item.original] = item.translation
										@t2o[locale.to_sym][item.translation] = item.original
									elsif !item.filter.blank? # Slug belongs to other application
										url = RicUrl.available_filter_urls[item.filter.to_sym]
										if !url.blank?
											@o2t[locale.to_sym][item.original] = url.trim("/") + item.translation
										end
									end
								else
									@o2t[locale.to_sym][item.original] = item.translation
									@t2o[locale.to_sym][item.translation] = item.original
								end
							end

						end

					end

					#
					# Get translation according to original
					#
					def original_to_translation(locale, original)
						load_cache(locale)

						# First priority translation (without IDs)
						result = @o2t[locale.to_sym][original.to_s]
						if result.nil?

							# Ensure single "/" on right
							original = original.rtrim("/") + "/"

							# Create array of all matched IDs alongside with string ":id" (i.e. [["1", ":id"], ["2", ":id"]]) 
							# Subsitude all numeric IDs in original to string ":id"
							matched_ids = []
							product_1 = []
							original = original.gsub(/\/[0-9]+\//) do |matched|
								matched_id = matched[1..-2]
								matched_ids << matched_id
								product_1 << [matched_id, ":id"]
								"/:id/"
							end

							if !product_1.empty?
								
								# Create product of matched IDs (i.e. [["1", "2"], ["1", ":id"], [":id", "2"], [":id", ":id"]])
								product_2 = product_1.first.product(*product_1[1..-1])
							
								# Try to find some result for all combinations (except first one, which is already tried and failed)
								result_ids = nil
								product_2[1..-1].each do |combined_ids|

									# IDs missing in this combination
									result_ids = []

									# Generate original acording to current combination (i.e. "/nodes/1/photos/:id" or "/nodes/:id/photos/:id")
									index = 0
									product_original = original.gsub(/\/:id\//) do
										result_ids << matched_ids[index] if combined_ids.first == ":id"
										index += 1
										"/#{combined_ids.shift.to_s}/"
									end

									# Remove "/" on right
									product_original = product_original.rtrim("/")

									# Try to translate current combination and break if match found
									result = @o2t[locale.to_sym][product_original.to_s]
									break if !result.nil?

								end

								# Correct result if any
								if !result.nil?

									# Ensure single "/" on right
									result = result.rtrim("/") + "/" 

									# Substitute :id to numeric IDS matched from translation
									result = result.gsub(/\/:id\//) do
										"/#{result_ids.shift.to_s}/"
									end

									# Remove "/" on right
									result = result.rtrim("/")

								end

							end

						end

						return result
					end

					#
					# Get original according to translation
					#
					def translation_to_original(locale, translation)
						load_cache(locale)

						# Downcase if necessary
						translation = translation.downcase if RicUrl.downcase_translations == true
						
						# First priority translation (without IDs)
						result = @t2o[locale.to_sym][translation.to_s] 
						if result.nil?
							
							# Ensure single "/" on right
							translation = translation.rtrim("/") + "/" 
							
							# Substitute numeric parts to :id
							matched_ids = []
							translation = translation.gsub(/\/[0-9]+\//) do |matched|
								matched_ids << matched[1..-2]
								"/:id/"
							end

							# Remove "/" on right
							translation = translation.rtrim("/")

							# Second priority translation (width IDs)
							result = @t2o[locale.to_sym][translation.to_s]
							if !result.nil?

								# Ensure single "/" on right
								result = result.rtrim("/") + "/" 

								# Substitute :id to numeric IDS matched from translation
								result = result.gsub(/\/:id\//) do
									"/#{matched_ids.shift.to_s}/"
								end

								# Remove "/" on right
								result = result.rtrim("/")

							end
						end

						return result
					end

					#
					# Add new slug or edit existing
					#
					def add_slug(locale, original, translation, filter = nil)
						
						# Do not process blank
						return if original.blank? # || translation.blank? blank translation means that original translates to root

						# Prepare
						locale = locale.to_s
						original = "/" + original.to_s.trim("/")
						translation = "/" + translation.to_s.trim("/")

						# Root is not slugged
						return if original == "/"
						
						# Try to find existing record
						slug = where(locale: locale, original: original).first
						if slug.nil?
							slug = new
						end

						# TODO duplicate translations

						# Save
						slug.locale = locale
						slug.filter = filter if RicUrl.use_filter == true
						slug.original = original
						slug.translation = translation
						slug.save

						# Clear cache
						clear_cache

					end

					#
					# Remove existing slug if exists
					#
					def remove_slug(locale, original)
						
						# Prepare
						locale = locale.to_s
						original = "/" + original.to_s.trim("/")

						# Try to find existing record
						slug = where(locale: locale, original: original).first						
						if !slug.nil?
							slug.destroy
						end

						# Clear cache
						clear_cache

					end

					#
					# Compose translation from various models
					#
					# Obsolete, please define own translation composition method
					#
					def compose_translation(locale, models)

						# Convert to array
						if !models.is_a? Array
							models = [ models ]
						end

						# Result
						result = ""
						last_model = nil
						last_model_is_category = false

						models.each do |section_options|
							
							# Input check
							if !section_options.is_a? Hash
								raise "Incorrect input, expecting hash with :label and :models or :model items."
							end
							if section_options[:models].nil? && !section_options[:model].nil?
								section_options[:models] = [ section_options[:model] ]
							end
							if section_options[:models].nil? || section_options[:label].nil?
								raise "Incorrect input, expecting hash with :label and :models or :model items."
							end

							# "Is category" option
							last_model_is_category = section_options[:is_category] == true

							section_options[:models].each do |model|

								# Get part
								if model.respond_to?("#{section_options[:label].to_s}_#{locale.to_s}".to_sym)
									part = model.send("#{section_options[:label].to_s}_#{locale.to_s}".to_sym)
								elsif model.respond_to?(section_options[:label].to_sym)
									part = model.send(section_options[:label].to_sym)
								else
									part = nil
								end

								# Add part to result
								result += "/" + part.to_url if part

								# Save last model
								last_model = model

							end

						end

						# Truncate correctly
						if !result.blank?
							if last_model_is_category || (last_model.hierarchically_ordered? && !last_model.leaf?)
								result += "/"
							else
								#result += ".html"
								result += ""
							end	
						end

						return result						
					end

					# *********************************************************
					# Columns
					# *********************************************************
					
					def permitted_columns
						[
							:locale,
							:original,
							:translation,
							:filter,
						]
					end

					def filter_columns
						[
							:locale,
							:original,
							:translation,
							:filter,
						]
					end

					# *********************************************************
					# Scopes
					# *********************************************************
					
					def filter(params = {})
						
						# Preset
						result = all

						# Locale
						if !params[:locale].blank?
							if RicUrl.disable_unaccent == true
								result = result.where("lower(locale) LIKE ('%' || lower(trim(?)) || '%')", params[:locale].to_s)
							else
								result = result.where("lower(unaccent(locale)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:locale].to_s)
							end
						end

						# Original
						if !params[:original].blank?
							if RicUrl.disable_unaccent == true
								result = result.where("lower(original) LIKE ('%' || lower(trim(?)) || '%')", params[:original].to_s)
							else
								result = result.where("lower(unaccent(original)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:original].to_s)
							end
						end

						# Translation
						if !params[:translation].blank?
							if RicUrl.disable_unaccent == true
								result = result.where("lower(translation) LIKE ('%' || lower(trim(?)) || '%')", params[:translation].to_s)
							else
								result = result.where("lower(unaccent(translation)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:translation].to_s)
							end
						end

						# Filter
						if RicUrl.use_filter == true
							if !params[:filter].blank?
								if RicUrl.disable_unaccent == true
									result = result.where("lower(filter) LIKE ('%' || lower(trim(?)) || '%')", params[:filter].to_s)
								else
									result = result.where("lower(unaccent(filter)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:filter].to_s)
								end
							end
						end
					
						result
					end

				end

			end
		end
	end
end
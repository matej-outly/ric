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

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
				end

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

							data = where(slug_locale: locale.to_s)
							data.each do |item|
								@o2t[locale.to_sym][item.original] = item.translation
								@t2o[locale.to_sym][item.translation] = item.original
							end

						end

					end

					#
					# Get translation according to original
					#
					def original_to_translation(locale, original)
						load_cache(locale)
						return @o2t[locale.to_sym][original.to_s]
					end

					#
					# Get original according to translation
					#
					def translation_to_original(locale, translation)
						load_cache(locale)
						return @t2o[locale.to_sym][translation.to_s]
					end

					#
					# Add new slug or edit existing
					#
					def add_slug(locale, original, translation)
						
						# Do not process blank
						return if translation.blank? || original.blank?

						# Prepare
						locale = locale.to_s
						original = "/" + original.to_s.trim("/")
						translation = "/" + translation.to_s.trim("/")

						# Root is not slugged
						return if original == "/"
						
						# Try to find existing record
						slug = where(slug_locale: locale, original: original).first						
						if slug.nil?
							slug = new
						end

						# TODO duplicate translations

						# Save
						slug.slug_locale = locale
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
						slug = where(slug_locale: locale, original: original).first						
						if !slug.nil?
							slug.destroy
						end

						# Clear cache
						clear_cache

					end

					#
					# Compose translation from various models
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
							:slug_locale,
							:original,
							:translation
						]
					end

					def filter_columns
						[
							:slug_locale,
							:original,
							:translation
						]
					end

					# *********************************************************
					# Scopes
					# *********************************************************
					
					def filter(params = {})
						
						# Preset
						result = all

						# Locale
						if !params[:slug_locale].blank?
							if config(:disable_unaccent) == true
								result = result.where("lower(slug_locale) LIKE ('%' || lower(trim(?)) || '%')", params[:slug_locale].to_s)
							else
								result = result.where("lower(unaccent(slug_locale)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:slug_locale].to_s)
							end
						end

						# Original
						if !params[:original].blank?
							if config(:original) == true
								result = result.where("lower(original) LIKE ('%' || lower(trim(?)) || '%')", params[:original].to_s)
							else
								result = result.where("lower(unaccent(original)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:original].to_s)
							end
						end

						# Translation
						if !params[:translation].blank?
							if config(:disable_unaccent) == true
								result = result.where("lower(translation) LIKE ('%' || lower(trim(?)) || '%')", params[:translation].to_s)
							else
								result = result.where("lower(unaccent(translation)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:translation].to_s)
							end
						end
					
						result
					end

				end

			end
		end
	end
end
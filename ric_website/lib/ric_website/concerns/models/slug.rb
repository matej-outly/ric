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

module RicWebsite
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
					# Load specific language to cache
					#
					def load_cache(language)

						# Initialize cache structures
						if @o2t.nil?
							@o2t = {}
						end
						if @t2o.nil?
							@t2o = {}
						end

						# Fill cache if empty
						if @o2t[language.to_sym].nil? || @t2o[language.to_sym].nil?
							
							@o2t[language.to_sym] = {}
							@t2o[language.to_sym] = {}

							data = where(slug_language: language.to_s)
							data.each do |item|
								@o2t[language.to_sym][item.original] = item.translation
								@t2o[language.to_sym][item.translation] = item.original
							end

						end

					end

					#
					# Get translation according to original
					#
					def original_to_translation(language, original)
						load_cache(language)
						return @o2t[language.to_sym][original.to_s]
					end

					#
					# Get original according to translation
					#
					def translation_to_original(language, translation)
						load_cache(language)
						return @t2o[language.to_sym][translation.to_s]
					end

					#
					# Add new slug or edit existing
					#
					def add_slug(language, original, translation)
						
						# Do not process blank
						return if translation.blank? || original.blank?

						# Prepare
						language = language.to_s
						original = "/" + original.to_s.trim("/")
						translation = "/" + translation.to_s.trim("/")

						# Root is not slugged
						return if original == "/"
						
						# Try to find existing record
						slug = where(slug_language: language, original: original).first						
						if slug.nil?
							slug = new
						end

						# TODO duplicate translations

						# Save
						slug.slug_language = language
						slug.original = original
						slug.translation = translation
						slug.save

						# Clear cache
						clear_cache

					end

					#
					# Remove existing slug if exists
					#
					def remove_slug(language, original)
						
						# Prepare
						language = language.to_s
						original = "/" + original.to_s.trim("/")

						# Try to find existing record
						slug = where(slug_language: language, original: original).first						
						if !slug.nil?
							slug.destroy
						end

						# Clear cache
						clear_cache

					end

					#
					# Compose translation from various models
					#
					def compose_translation(language, models)

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
								if model.respond_to?("#{section_options[:label].to_s}_#{language.to_s}".to_sym)
									part = model.send("#{section_options[:label].to_s}_#{language.to_s}".to_sym)
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
								result += ".html"
							end	
						end

						return result						
					end

				end

			end
		end
	end
end
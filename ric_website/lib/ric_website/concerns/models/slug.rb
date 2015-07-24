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

				end

			end
		end
	end
end
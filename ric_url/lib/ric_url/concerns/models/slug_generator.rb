# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Linear slug generator
# *
# * Author: Matěj Outlý
# * Date  : 21. 7. 2015
# *
# *****************************************************************************

module RicUrl
	module Concerns
		module Models
			module SlugGenerator extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					after_save :generate_slugs

					before_destroy :destroy_slugs, prepend: true

				end

				module ClassMethods

					def generate_slugs(options = {})
						self.all.each do |item|
							item.generate_slugs(options)
						end
					end

				end

				# *************************************************************
				# Hooks
				# *************************************************************

				def generate_slugs(options = {})
					
					# Generate slug in this model
					if !RicUrl.slug_model.nil?
						I18n.available_locales.each do |locale|
							self._destroy_slug_was(RicUrl.slug_model, locale)
							self._generate_slug(RicUrl.slug_model, locale)
						end
					end

				end

				def destroy_slugs(options = {})

					# Destroy slug of this model
					if !RicUrl.slug_model.nil?
						I18n.available_locales.each do |locale|
							self._destroy_slug(RicUrl.slug_model, locale)
						end
					end

				end

				def url_original
					if @url_original.nil?
						@url_original = self._url_original
					end
					return @url_original
				end

				def compose_slug_translation(locale)
					return self._compose_slug_translation(locale)
				end

			protected

				# *************************************************************
				# Callbacks to be defined in apllication
				# *************************************************************

				def _url_original
					raise "To be defined in application."
				end

				def _compose_slug_translation(locale)
					raise "To be defined in application."
				end

				def _generate_slug(slug_model, locale)
					raise "To be defined in application."
				end

				def _destroy_slug(slug_model, locale)
					raise "To be defined in application."
				end

				def _destroy_slug_was(slug_model, locale)
					raise "To be defined in application."
				end

			end
		end
	end
end

# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Hierarchical slug generator
# *
# * Author: Matěj Outlý
# * Date  : 21. 7. 2015
# *
# *****************************************************************************

module RicUrl
	module Concerns
		module Models
			module HierarchicalSlugGenerator extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					after_save :generate_slugs

					before_destroy :destroy_slugs_before, prepend: true

					after_destroy :destroy_slugs_after

				end

				def disable_slug_generator
					@disable_slug_generator = true
				end

				def enable_slug_generator
					@disable_slug_generator = false
				end

				# *************************************************************
				# Hooks
				# *************************************************************

				def generate_slugs(options = {})
					return if @disable_slug_generator == true

					# Generate slug in this model
					if !RicUrl.slug_model.nil?
						I18n.available_locales.each do |locale|
							self._destroy_slug_was(RicUrl.slug_model, locale)
							self._generate_slug(RicUrl.slug_model, locale)
						end
					end

					# Propagate to other models
					if options[:disable_propagation] != true
						
						# Propagate to parent
						self.parent.generate_slugs(disable_propagation: true) if self.parent

						# Propagate to descendants
						self.descendants.each do |descendant|
							descendant.generate_slugs(disable_propagation: true)
						end

					end

				end

				def destroy_slugs_before(options = {})

					# Destroy slug of this model
					if !RicUrl.slug_model.nil?
						I18n.available_locales.each do |locale|
							self._destroy_slug(RicUrl.slug_model, locale)
						end
					end

					# Propagate to other models
					if options[:disable_propagation] != true
						
						# Propagate to descendants
						self.descendants.each do |descendant|
							descendant.destroy_slugs_before(disable_propagation: true)
						end

					end

				end

				def destroy_slugs_after(options = {})

					# Propagate to other models
					if options[:disable_propagation] != true
						
						# Propagate to parent
						self.parent.generate_slugs(disable_propagation: true) if self.parent

					end

				end

			protected

				# *************************************************************
				# Callbacks to be defined in apllication
				# *************************************************************

				def _generate_slug(slug_model, locale)
					raise "No be defined in application."
				end

				def _destroy_slug(slug_model, locale)
					raise "No be defined in application."
				end

				def _destroy_slug_was(slug_model, locale)
					raise "No be defined in application."
				end


			end
		end
	end
end

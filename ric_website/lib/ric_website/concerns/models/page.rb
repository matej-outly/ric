# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Page extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to menus
					#
					has_and_belongs_to_many :menus, class_name: RicWebsite.menu_model.to_s if RicWebsite.enable_menus

					#
					# Relation to common model
					#
					belongs_to :model, polymorphic: true

					#
					# Relation to page blocks
					#
					has_many :page_blocks, class_name: RicWebsite.page_block_model.to_s

					#
					# Ordering
					#
					enable_hierarchical_ordering

					#
					# Check model consistency before save
					#
					before_save :check_model_consistency

					# *********************************************************
					# Attachments
					# *********************************************************

					#
					# Background
					#
					has_attached_file :background, :styles => { :thumb => config(:background_crop, :thumb), :full => config(:background_crop, :full) }
					validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

					# *********************************************************
					# Key
					# *********************************************************

					#
					# Key enum
					#
					enum_column :key, config(:keys) if config(:enable_key)

					# *********************************************************
					# Localization
					# *********************************************************

					if RicWebsite.localization
						localized_column :title
						localized_column :meta_title
						localized_column :meta_description
					end

				end

				module ClassMethods

					#
					# Parts
					#
					def parts
						result = [:basic, :design, :meta, :structure]
						result << :menus if RicWebsite.enable_menus
						return result
					end

					#
					# Columns
					#
					def basic_part_columns
						result = []
						[:title].each do |column|
							if RicWebsite.localization
								I18n.available_locales.each do |locale|
									result << "#{column.to_s}_#{locale.to_s}".to_sym
								end
							else
								result << column
							end
						end
						[:key, :parent_id, :nature, :model_id, :url].each do |column|
							result << column
						end
						return result
					end

					#
					# Columns
					#
					def design_part_columns
						[:layout, :background]
					end

					#
					# Columns
					#
					def meta_part_columns
						result = []
						[:meta_title, :meta_description].each do |column|
							if RicWebsite.localization
								I18n.available_locales.each do |locale|
									result << "#{column.to_s}_#{locale.to_s}".to_sym
								end
							else
								result << column
							end
						end
						return result
					end

					#
					# Columns
					#
					def structure_part_columns
						[]
					end

					#
					# Columns
					#
					def menus_part_columns
						[]
					end

					#
					# Get homepage
					#
					def homepage
						where(nature: "home").first
					end

				end

				# *************************************************************
				# Title with depth
				# *************************************************************

				def title_with_depth(delimiter = " - ")
					return (delimiter * self.depth.to_i) + self.title.to_s
				end

				# *************************************************************
				# URL / Path
				# *************************************************************

				#
				# Is URL generated automatically
				#
				def automatic_url
					return !self.nature.blank? && !config(:natures, self.nature.to_sym, :url).blank?
				end

				#
				# Generate path
				#
				def generate_url
					if !self.nature.blank?
						url_template = config(:natures, self.nature.to_sym, :url)
						if !url_template.blank?
							url_template = url_template.to_s

							# Binded page
							url_template = url_template.gsub(/:page_id/, self.id.to_s)
							url_template = url_template.gsub(/:page_key/, self.key.to_s)

							# Binded model
							if !self.model.nil?
								if self.model.respond_to?(:id)
									url_template = url_template.gsub(/:model_id/, self.model.id.to_s)
								end
								if self.model.respond_to?(:key)
									url_template = url_template.gsub(/:model_key/, self.model.key.to_s)
								end
							end

							# Store generated url
							self.url = url_template
						end
					end
				end

				#
				# Check if page active in the given request
				#
				def active_url?(request)
					return false if !request || !self.url
					current_locale, current_path = RicWebsite::Helpers::LocaleHelper.disassemble(request.fullpath)
					if self.url == "/"
						return current_path == "/"
					else
						return current_path.start_with?(self.url)
					end
				end

				# *************************************************************
				# Model
				# *************************************************************

				#
				# Check consistency of model polymorphic relation 
				#
				def check_model_consistency
					if !self.nature.blank?
						model_classname = config(:natures, self.nature.to_sym, :model)
					end
					if !model_classname.blank? && !self.model_id.blank?
						model_class = model_classname.constantize
						model = model_class.find_by_id(self.model_id)
						if !model.nil?
							self.model_type = model_classname
							return true
						end
					end
					self.model_id = nil
					self.model_type = nil
					return true
				end

				#
				# Get all available models
				#
				def available_models
					if !self.nature.blank?
						model_classname = config(:natures, self.nature.to_sym, :model)
					end
					if !model_classname.blank?
						model_class = model_classname.constantize
						return model_class.where(config(:natures, self.nature.to_sym, :filters)).order(id: :asc)
					else
						return []
					end
				end

			protected

				# *************************************************************
				# Slug
				# *************************************************************

				def _generate_slug(slug_model, locale)
					if !self.url.blank?
						translation = slug_model.compose_translation(
							locale, 
							models: self.self_and_ancestors, 
							label: :title
						)
						slug_model.add_slug(locale, URI.parse(self.url).path, translation)
					end
				end

				def _destroy_slug(slug_model, locale)
					if !self.url.blank?
						slug_model.remove_slug(locale, URI.parse(self.url).path)
					end
				end

				def _destroy_slug_was(slug_model, locale)
					if self.url_was != self.url && !self.url_was.blank?
						slug_model.remove_slug(locale, URI.parse(self.url_was).path)
					end
				end

			end
		end
	end
end
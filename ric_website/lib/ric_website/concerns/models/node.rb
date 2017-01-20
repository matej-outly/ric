# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Node extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :structure
					has_many :field_values, dependent: :destroy
					has_many :node_attachments, dependent: :destroy

					# *********************************************************
					# Hierarchy
					# *********************************************************

					enable_hierarchical_ordering

					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :name

					# *********************************************************
					# Structure
					# *********************************************************

					add_methods_to_json :structure_icon

					before_validation :synchronize_from_parent_structure

					# *********************************************************
					# Navigation
					# *********************************************************

					add_methods_to_json :navigation_name

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

					#
					# Filter
					#
					def filter(params)
						
						# Preset
						result = all

						# Name
						if !params[:name].blank?
							result = result.where("lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:name].to_s)
						end

						result
					end

					#
					# Search
					#
					def search(query)
						if query.blank?
							all
						else
							where("
								(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))
							", query: query.to_s)
						end
					end

					# *********************************************************
					# Slugs
					# *********************************************************

					def self.slugify_value(value)
						value = value.to_s.gsub(/href=["'][^"'\^]+["']/) do |match| 
							original = match[6..-2]
							if original.starts_with?("/nodes/")
								node_id = original[7..-1].to_i
								node = Node.find_by_id(node_id)
								original = node.url_original if node
								# Translate ...
							else
								translation = original
								# Do not translate
							end
							if translation.nil?
								translation = RicUrl::Helpers::SlugHelper.slugify(RicUrl::Helpers::LocaleHelper.localify(original))
							end
							"href=\"#{translation}\""
						end
						return value
					end

					# *********************************************************
					# Columns
					# *********************************************************
					
					#
					# Get all columns permitted for editation (see instance 
					# method permitted columns)
					#
					def permitted_columns
						raise "Not implemented."
					end

				end

				# *************************************************************
				# Columns
				# *************************************************************

				def permitted_columns
					self.permitted_field_refs.dup.concat([
						:structure_id,
						:parent_id,
						:name,
						:ref,
					])
				end

				# *************************************************************
				# Structure
				# *************************************************************

				def change_structure(new_structure)
					return if new_structure.nil?
					
					@permitted_fields = nil
					@permitted_field_refs = nil
					@field_values = nil

					# Disable slugs for the opration
					self.disable_slug_generator

					# Save old data
					data = {}
					self.field_values.each do |field_value|
						data[field_value.ref] = field_value.value
					end

					# Destroy old field values
					self.field_values.destroy_all

					# Define new structure
					self.structure_id = new_structure.id
					self.save

					# Define new field values
					new_structure.fields.each do |field|
						self.write_field(field.ref, data[field.ref])
					end

					# Regenerate slugs
					self.enable_slug_generator
					self.generate_slugs

					return true
				end

				def structure_icon
					if @structure_icon.nil?
						@structure_icon = self.structure.icon if self.structure
					end
					return @structure_icon
				end

				def synchronize_from_parent_structure 
					if self.structure
						self.show_in_navigation = self.structure.show_in_navigation
						self.is_navigable = self.structure.is_navigable 
						self.has_attachments = self.structure.has_attachments 
						self.has_pictures = self.structure.has_pictures 
					else
						self.show_in_navigation = nil
						self.is_navigable = nil
						self.has_attachments = nil
						self.has_pictures = nil						
					end
					return true
				end

				# *************************************************************
				# Fields
				# *************************************************************

				def permitted_fields
					if @permitted_fields.nil?
						if self.structure
							@permitted_fields = self.structure.fields.order(position: :asc)
						else
							@permitted_fields = []
						end
					end
					return @permitted_fields
				end

				def permitted_field_refs
					if @permitted_field_refs.nil?
						@permitted_field_refs = []
						@permitted_field_belongs_to_refs = {}
						self.permitted_fields.each do |field| 
							@permitted_field_refs << field.ref.to_sym
							if field.kind == "belongs_to" && field.ref.ends_with?("_id")
								@permitted_field_belongs_to_refs[field.ref[0..-4].to_sym] = field.ref.to_sym
							end
						end
					end
					return @permitted_field_refs
				end

				def permitted_field_belongs_to_refs
					self.permitted_field_refs # To initialize returned hash
					return @permitted_field_belongs_to_refs
				end

				def read_field(ref, options)
					@field_values = {} if @field_values.nil?
					if !@field_values.key?(ref.to_sym)
						@field_values[ref.to_sym] = self.field_values.find_by(ref: ref.to_s)
					end
					if @field_values[ref.to_sym]
						if options[:obj] == true
							value = @field_values[ref.to_sym].value_obj
						else
							value = @field_values[ref.to_sym].value
						end
						return value
					else
						return nil
					end
				end

				def write_field(ref, new_value)
					@field_values = {} if @field_values.nil?
					if !self.permitted_field_refs.include?(ref.to_sym)
						raise "Unknown field '#{ref}'."
					end
					field_value = self.field_values.find_by(ref: ref.to_s) # Find
					if field_value.nil? # Or create
						field = self.structure.fields.find_by(ref: ref.to_s)
						field_value = self.field_values.create(
							field_id: field.id, 
							kind: field.kind, # In order to correctly save value
							enum_id: field.enum_id
						)
					end
					field_value.value = new_value
					field_value.save
					@field_values.delete(ref.to_sym)
					return new_value
				end

				def method_missing(name, *arguments)
					options = {}
					
					# Modifiers
					if name.to_s.ends_with?("_obj")
						name = name.to_s[0..-5].to_sym
						options[:obj] = true
					end

					# Belongs to
					if self.permitted_field_belongs_to_refs.include?(name.to_sym)
						name = self.permitted_field_belongs_to_refs[name.to_sym]
						options[:obj] = true
					end

					if self.permitted_field_refs.include?(name.to_sym)
						self.read_field(name.to_sym, options)
					elsif self.permitted_field_refs.map{ |ref| (ref.to_s + "=").to_sym }.include?(name.to_sym) 
						if arguments.length != 1
							raise "Wrong number of arguments (given #{arguments.length}, expected 1)"
						end
						self.write_field(name.to_s[0..-2], arguments.first)
					else
						super
					end
				end

				def name=(new_name)
					if self.permitted_field_refs.include?(:name)
						self.write_field(:name, new_name)
					end
					write_attribute(:name, new_name)
				end

				# *************************************************************
				# Slugs
				# *************************************************************

				def slug
					if @slug.nil?
						url = self.url_original
						@slug = RicUrl::Helpers::SlugHelper.slugify(RicUrl::Helpers::LocaleHelper.localify(url))
						@slug = nil if url == @slug
					end
					return @slug
				end

				def include_in_url
					if @include_in_url.nil?
						if self.structure
							@include_in_url = (self.structure.fields.where(include_in_url: true).count > 0)
						else
							@include_in_url = false
						end
					end
					return @include_in_url
				end

				def slugify_value(value)
					return self.class.slugify_value(value)
				end

				# *************************************************************
				# Navigation
				# *************************************************************

				def descendants_in_navigation(max_level = 2, level = 1)
					return [] if level > max_level # Stop at max level
					result = []
					self.children.order(lft: :asc).each do |child|
						if child.show_in_navigation == true
							result << child
						else 
							result.concat(child.descendants_in_navigation(max_level, level + 1))
						end
					end
					return result
				end

				def navigation_name
					if @navigation_name.nil?
						@navigation_name = ""
						self.self_and_ancestors.each do |node|
							if node.id == self.id || node.show_in_navigation == true || node.is_navigable == true 
								@navigation_name += "/ #{node.name.to_s} "
							end
						end
					end
					return @navigation_name
				end

			protected

				# *************************************************************
				# Slugs
				# *************************************************************

				def _url_original
					"/nodes/#{self.id}"
				end
				
				def _compose_slug_translation(locale)
					filter = nil
					translation = ""
					after_web_node = false
					self.self_and_ancestors.each do |node|
						
						if !after_web_node && node.structure && node.structure.ref == "web"
							filter = node.ref
							after_web_node = true
						end

						if after_web_node
							node.field_values.where(include_in_url: true).where("locale = ? OR locale IS NULL", locale).order(position: :asc).each do |field_value|
								if !field_value.slug.blank?
									translation += "/" + field_value.slug
								end
							end
						end
						
					end
					return [filter, translation]
				end

				def _generate_slug(slug_model, locale)
					if self.include_in_url
						filter, translation = compose_slug_translation(locale)
						slug_model.add_slug(locale, URI.parse(self.url_original).path, translation, filter) if !translation.blank?
					end
				end

				def _destroy_slug(slug_model, locale)
					if self.include_in_url
						slug_model.remove_slug(locale, URI.parse(self.url_original).path)
					end
				end

				def _destroy_slug_was(slug_model, locale)
					# Original URL did not change since it is derived from Node ID
				end

			end
		end
	end
end
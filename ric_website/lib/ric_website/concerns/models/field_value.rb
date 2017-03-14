# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Field/node value
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module FieldValue extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :node, class_name: RicWebsite.node_model.to_s
					belongs_to :field, class_name: RicWebsite.field_model.to_s
					belongs_to :enum, class_name: RicWebsite.enum_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :field_id, :node_id, :name, :ref, :kind

					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, [
						:string, 
						:text, 
						:boolean, 
						:integer, 
						:float, 
						:date, 
						:datetime, 
						:enum, 
						#:enum_array, 
						:belongs_to, 
						#:has_many
					]

					# *********************************************************
					# Field
					# *********************************************************

					before_validation :synchronize_from_parent_field

					# *********************************************************
					# Slug
					# *********************************************************

					before_save :generate_slug

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************
					
					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:field_id,
							:node_id,
							:value
						]
					end

				end

				# *************************************************************
				# Field
				# *************************************************************

				def synchronize_from_parent_field
					if self.field
						self.position = self.field.position
						self.name = self.field.name 
						self.ref = self.field.ref
						self.include_in_url = self.field.include_in_url
						self.kind = self.field.kind
						self.enum_id = self.field.enum_id
					end
					return true
				end

				# *************************************************************
				# Slug
				# *************************************************************

				def generate_slug
					if self.include_in_url
						self.slug = self.value.to_s.to_url
					else
						self.slug = nil
					end
					return true
				end

				# *************************************************************
				# Value
				# *************************************************************

				def value_obj
					value = self.value

					if !value.blank?
						
						# Enum
						if self.kind == "enum"
							label = self.enum.values[value]
							if label
								result = OpenStruct.new({
									value: value,
									label: label
								})
							else # Not found
								result = nil
							end

						# Belongs to
						elsif self.kind == "belongs_to"
							result = RicWebsite.node_model.find_by_id(value)
						
						# Other types without _obj support
						else
							result = nil
						end
					else
						result = nil
					end

					return result
				end

				def value
					if !self.class.available_kinds.map{ |kind| kind.value }.include?(self.kind)
						raise "Unknown kind."
					end
					result = self.send("value_#{self.kind}")
					return result
				end

				def value=(new_value)
					if !self.class.available_kinds.map{ |kind| kind.value }.include?(self.kind)
						raise "Unknown kind."
					end
					self.class.available_kinds.map{ |kind| kind.value }.each do |other_kind|
						if other_kind != self.kind
							self.send("value_#{other_kind}=", nil)
						end
					end
					self.send("value_#{self.kind}=", new_value)
				end

			end
		end
	end
end
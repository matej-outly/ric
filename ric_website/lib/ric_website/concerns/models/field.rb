# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Field
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Field extend ActiveSupport::Concern

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
					belongs_to :enum
					has_many :field_values, dependent: :destroy
					
					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :structure_id, :name, :ref, :kind


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
					# Field values
					# *********************************************************

					after_save :synchronize_nested_field_values

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
							:name,
							:ref,
							:include_in_url,
							:kind,
							:enum_id,
						]
					end

				end

				# *************************************************************
				# Field values
				# *************************************************************

				def synchronize_nested_field_values 
					self.field_values.update_all(
						position: self.position,
						name: self.name,
						ref: self.ref,
						include_in_url: self.include_in_url,
						kind: self.kind,
						enum_id: self.enum_id
					)
				end

			end
		end
	end
end
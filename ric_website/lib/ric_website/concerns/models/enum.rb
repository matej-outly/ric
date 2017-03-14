# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Enum
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Enum extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :fields, dependent: :destroy, class_name: RicWebsite.field_model.to_s
					has_many :field_values, dependent: :destroy, class_name: RicWebsite.field_value_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :name, :ref

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

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
					# Columns
					# *********************************************************
					
					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:name, 
							:ref,
							:values
						]
					end

				end

			end
		end
	end
end
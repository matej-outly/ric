# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customer
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicCustomer
	module Concerns
		module Models
			module Customer extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

				end

				module ClassMethods

					# *********************************************************
					# Filter scope
					# *********************************************************

					#
					# Scope definition
					#
					def filter(params = {})
						
						# Init
						@filter_columns = {} if !defined?(@filter_columns)

						# Symbolize all param keys
						params.symbolize_keys!

						# Preset
						where_values = {}
						where_string = ""
						first = true

						@filter_columns.each do |column, spec|

							if !params[column].blank? # Column found in params and not blank

								# Get column (filter) type
								type = spec[:type]
								
								# Get and validate used operator, use default if not valid
								operator_param = "#{column.to_s}_operator".to_sym
								operator = params[operator_param].to_sym if !params[operator_param].blank?
								operator = nil if !operator.nil? && !spec[:operators].include?(operator)
								operator = spec[:operators].first if operator.nil?

								# Get where sting part
								part_method = method("filter_type_#{type.to_sym}".to_sym)
								part = part_method.call(column, operator, params[column]) if !part_method.nil?

								# Save its value and compose string if part is valid
								if !part.nil?
									where_string = where_string + (first ? "" : " AND ") + "(" + part + ")"
									where_values[column] = params[column]
									first = false
								end

							end

						end

						where(where_string, where_values)
					end

					#
					# Compose where part for string
					#
					def filter_type_string(column, operator, unused_value)
						return case operator
							when :like then "lower(unaccent(#{column.to_s})) LIKE ('%' || lower(unaccent(trim(:#{column.to_s}))) || '%')"
							when :llike then "lower(unaccent(#{column.to_s})) LIKE ('%' || lower(unaccent(trim(:#{column.to_s}))) )"
							when :rlike then "lower(unaccent(#{column.to_s})) LIKE ( lower(unaccent(trim(:#{column.to_s}))) || '%')"
							else nil
						end
					end

					#
					# Compose where part for integer
					#
					def filter_type_integer(column, operator, unused_value)
						return case operator
							when :eq then "#{column.to_s} = :#{column.to_s}"
							when :lt then "#{column.to_s} < :#{column.to_s}"
							when :le then "#{column.to_s} <= :#{column.to_s}"
							when :gt then "#{column.to_s} > :#{column.to_s}"
							when :ge then "#{column.to_s} >= :#{column.to_s}"
							else nil
						end
					end

					#
					# Compose where part for boolean
					#
					def filter_type_boolean(column, operator, value)
						return case operator
							when :eq then "#{column.to_s} = :#{column.to_s}" + (value == "0" ? " OR #{column.to_s} IS NULL" : "")
							else nil
						end
					end

					#
					# Get all columns (array)
					#
					def filter_columns
						return @filter_columns
					end

					#
					# Define a column with filter ability
					#
					def define_filter_column(column, type, operators, options = {})
						@filter_columns = {} if !defined?(@filter_columns)
						@filter_columns[column.to_sym] = options
						@filter_columns[column.to_sym][:type] = type
						@filter_columns[column.to_sym][:operators] = operators
					end

					# *********************************************************
					# Statistic scope
					# *********************************************************

					#
					# Define statistic
					#
					def define_statistic(statistic, columns, &block)

						# Internal structures
						@statistic_columns = {} if !defined?(@statistic_columns)
						@statistic_columns[statistic.to_sym] = columns

						# Accessors
						columns.each do |column, spec| 
							attr_accessor(column.to_sym)
						end

						# Scope
						define_singleton_method(statistic.to_sym) do |params = {}|
							blank = false
							@statistic_columns[statistic.to_sym].each do |column, spec| 
								blank = true if params[column].blank?
							end
							if blank
								all
							else
								block.call(params)
							end
						end

						# Getter
						define_singleton_method("#{statistic.to_s}_columns".to_sym) do |column|
							@statistic_columns[statistic.to_sym]
						end

					end

				end

				# *************************************************************
				# Full name
				# *************************************************************

				def full_name
					if last_name.blank? || last_name.nil?
						return ( (first_name.blank? || first_name.nil?) ? "" : first_name)
					elsif first_name.blank? || first_name.nil?
						return ( (last_name.blank? || last_name.nil?) ? "" : last_name)
					else
						return first_name + " " + last_name
					end
				end

			end
		end
	end
end
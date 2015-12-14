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
						result = all

						@filter_columns.each do |column, spec|

							if !params[column].blank? && !(params[column].is_a?(::Array) && params[column].length == 1 && params[column][0].blank?) # Column found in params and not blank

								# Get column (filter) type
								type = spec[:type]
								
								# Get and validate used operator, use default if not valid
								operator_param = "#{column.to_s}_operator".to_sym
								operator = params[operator_param].to_sym if !params[operator_param].blank?
								operator = nil if !operator.nil? && !spec[:operators].include?(operator)
								operator = spec[:operators].first if operator.nil?

								# Check available methods
								where_composer_method = "filter_type_#{type.to_sym}".to_sym
								scope_method = "#{column.to_s}_#{operator.to_s}".to_sym
								
								if respond_to?(where_composer_method) # Get where string if composer found
								
									# Compose where string
									where_string = send(where_composer_method, column, operator, params[column])

									# Make where
									if !where_string.nil?
										result = where(where_string, {column => params[column]})
									end

								elsif respond_to?(scope_method) # Or call scope

									# Call scope
									result = send(scope_method, params[column])
								
								else
									raise "No way to filter #{column} found."
								end
							end
						end
						result
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
					# Get all columns
					#
					def filter_columns
						return @filter_columns
					end

					#
					# Get all columns formated for strong params
					#
					def filter_params
						result = []
						@filter_columns.each do |column, spec|
							if spec[:type] == :string_array
								result << { column => [] }
							else
								result << column
							end
						end
						return result
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
						define_singleton_method("#{statistic.to_s}_columns".to_sym) do
							@statistic_columns[statistic.to_sym]
						end

						# Getter
						define_singleton_method("#{statistic.to_s}_params".to_sym) do
							result = []
							@statistic_columns[statistic.to_sym].each do |column, spec|
								if spec[:type] == :string_array
									result << { column => [] }
								else
									result << column
								end
							end
							return result
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
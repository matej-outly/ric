# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Setting
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module SettingsCollection extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					#
					# Tableless
					#
					has_no_table

				end

				module ClassMethods

					#
					# Define a new setting
					#
					def setting(new_key, kind, category, options = {})

						# Initialize
						@settings = {} if @settings.nil?
						new_key = new_key.to_sym

						# Store
						@settings[new_key] = options
						@settings[new_key][:kind] = kind
						@settings[new_key][:category] = category

						# Define tableless column
						if kind == :string # String
							column new_key, :varchar

						elsif kind == :integer # Integer
							column new_key, :integer

						elsif kind == :enum # Enum
							if !options[:values]
								raise "Please define values for setting #{new_key.to_s} with enum kind."
							end
							column new_key, :varchar
							enum_column new_key, options[:values]

						else
							raise "Unknown kind #{kind.to_s} of setting #{new_key.to_s}."
						end

						# Get method
						define_method(new_key) do
							key = new_key
							@settings_values = {} if @settings_values.nil?
							@settings_values[key] = self.get(key) if !@settings_values[key]
							return @settings_values[key]
						end

						# Set method
						define_method((new_key.to_s + "=").to_sym) do |value|
							key = new_key
							@settings_values = {} if @settings_values.nil?
							@settings_values[key] = value
						end

					end

					#
					# Get all defined settings
					#
					def settings
						@settings
					end

					#
					# Get all categories and contained settings
					#
					def categories
						result = {}
						@settings.each do |setting_key, setting_options|
							if setting_options[:category]
								if result[setting_options[:category]].nil?
									result[setting_options[:category]] = []
								end
								result[setting_options[:category]] << setting_key
							end
						end
						return result
					end

				end

				#
				# Get all defined settings
				#
				def settings
					self.class.settings
				end

				#
				# Get all categories and contained settings
				#
				def categories
					self.class.categories
				end

				#
				# Store all modified values before save
				#
				def save
					@settings_values.each do |key, value|
						self.set(key, value)
					end
					return true
				end

			protected

				def get(key)
					return RicWebsite.setting_model.find_or_create_by(key: key.to_s).value
				end

				def set(key, value)
					object = RicWebsite.setting_model.find_or_create_by(key: key.to_s)
					object.value = value
					return object.save
				end

			end
		end
	end
end
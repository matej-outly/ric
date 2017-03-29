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

module RicSettings
	module Concerns
		module Models
			module SettingsCollection extend ActiveSupport::Concern

				module ClassMethods

					#
					# Define a new setting
					#
					def setting(new_key, kind, category, options = {})

						# Initialize
						@settings = {} if @settings.nil?
						@permitted_columns = [] if @permitted_columns.nil?
						new_key = new_key.to_sym
						keys_to_define = [new_key]

						# Store
						@settings[new_key] = options
						@settings[new_key][:kind] = kind
						@settings[new_key][:category] = category

						# Define tableless column
						if kind == :string # String
							attr_accessor new_key
							#column new_key, :varchar
							@permitted_columns << new_key.to_sym

						elsif kind == :integer # Integer
							attr_accessor new_key
							#column new_key, :integer
							@permitted_columns << new_key.to_sym

						elsif kind == :currency # Currency
							attr_accessor new_key
							#column new_key, :integer
							@permitted_columns << new_key.to_sym

						elsif kind == :enum # Enum
							if !options[:values]
								raise "Please define values for setting #{new_key.to_s} with enum kind."
							end
							attr_accessor new_key
							#column new_key, :varchar
							enum_column new_key, options[:values]
							@permitted_columns << new_key.to_sym

						elsif kind == :integer_range
							attr_accessor "#{new_key.to_s}_min".to_sym
							attr_accessor "#{new_key.to_s}_max".to_sym
							#column "#{new_key.to_s}_min".to_sym, :integer
							#column "#{new_key.to_s}_max".to_sym, :integer
							range_column new_key
							keys_to_define = ["#{new_key.to_s}_min".to_sym, "#{new_key.to_s}_max".to_sym]
							@permitted_columns << { new_key.to_sym => [ :min, :max ] }

						elsif kind == :double_range
							attr_accessor "#{new_key.to_s}_min".to_sym
							attr_accessor "#{new_key.to_s}_max".to_sym
							#column "#{new_key.to_s}_min".to_sym, :varchar
							#column "#{new_key.to_s}_max".to_sym, :varchar
							range_column new_key
							keys_to_define = ["#{new_key.to_s}_min".to_sym, "#{new_key.to_s}_max".to_sym]
							@permitted_columns << { new_key.to_sym => [ :min, :max ] }

						else
							raise "Unknown kind #{kind.to_s} of setting #{new_key.to_s}."
						end

						keys_to_define.each do |key_to_define|
							
							# Get method
							define_method(key_to_define) do
								key = key_to_define
								@settings_values = {} if @settings_values.nil?
								@settings_values[key] = self.get(key) if !@settings_values[key]
								return @settings_values[key]
							end

							# Set method
							define_method((key_to_define.to_s + "=").to_sym) do |value|
								key = key_to_define
								@settings_values = {} if @settings_values.nil?
								@settings_values[key] = value
							end

						end

					end

					#
					# Get all defined settings
					#
					def settings
						@settings = {} if @settings.nil?
						@settings
					end

					#
					# Get all categories and contained settings
					#
					def categories
						result = {}
						self.settings.each do |setting_key, setting_options|
							if setting_options[:category]
								if result[setting_options[:category]].nil?
									result[setting_options[:category]] = []
								end
								result[setting_options[:category]] << setting_key
							end
						end
						return result
					end

					#
					# Get all columns permitted for update via request
					#
					def permitted_columns
						@permitted_columns = [] if @permitted_columns.nil?
						return @permitted_columns
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
				# Get all columns permitted for update via request
				#
				def permitted_columns
					self.class.permitted_columns
				end

				def assign_attributes(attributes)
					attributes.each do |key, value|
						self.send("#{key}=", value)
					end
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
					return RicSettings.setting_model.find_or_create_by(key: key.to_s).value
				end

				def set(key, value)
					object = RicSettings.setting_model.find_or_create_by(key: key.to_s)
					object.value = value
					#object.kind = self.settings[key.to_sym][:kind]
					#object.category = self.settings[key.to_sym][:category]
					return object.save
				end

			end
		end
	end
end
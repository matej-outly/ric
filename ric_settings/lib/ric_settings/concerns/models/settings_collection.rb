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
					def setting(new_ref, kind, category, options = {})

						# Initialize
						@settings = {} if @settings.nil?
						@permitted_columns = [] if @permitted_columns.nil?
						new_ref = new_ref.to_sym
						refs_to_define = [new_ref]

						# Store
						@settings[new_ref] = options
						@settings[new_ref][:kind] = kind
						@settings[new_ref][:category] = category

						# Define tableless column
						if kind == :string # String
							attr_accessor new_ref
							#column new_ref, :varchar
							@permitted_columns << new_ref.to_sym

						elsif kind == :integer # Integer
							attr_accessor new_ref
							#column new_ref, :integer
							@permitted_columns << new_ref.to_sym

						elsif kind == :currency # Currency
							attr_accessor new_ref
							#column new_ref, :integer
							@permitted_columns << new_ref.to_sym

						elsif kind == :enum # Enum
							if !options[:values]
								raise "Please define values for setting #{new_ref.to_s} with enum kind."
							end
							attr_accessor new_ref
							#column new_ref, :varchar
							enum_column new_ref, options[:values]
							@permitted_columns << new_ref.to_sym

						elsif kind == :integer_range
							attr_accessor "#{new_ref.to_s}_min".to_sym
							attr_accessor "#{new_ref.to_s}_max".to_sym
							#column "#{new_ref.to_s}_min".to_sym, :integer
							#column "#{new_ref.to_s}_max".to_sym, :integer
							range_column new_ref
							refs_to_define = ["#{new_ref.to_s}_min".to_sym, "#{new_ref.to_s}_max".to_sym]
							@permitted_columns << { new_ref.to_sym => [ :min, :max ] }

						elsif kind == :double_range
							attr_accessor "#{new_ref.to_s}_min".to_sym
							attr_accessor "#{new_ref.to_s}_max".to_sym
							#column "#{new_ref.to_s}_min".to_sym, :varchar
							#column "#{new_ref.to_s}_max".to_sym, :varchar
							range_column new_ref
							refs_to_define = ["#{new_ref.to_s}_min".to_sym, "#{new_ref.to_s}_max".to_sym]
							@permitted_columns << { new_ref.to_sym => [ :min, :max ] }

						else
							raise "Unknown kind #{kind.to_s} of setting #{new_ref.to_s}."
						end

						refs_to_define.each do |ref_to_define|
							
							# Get method
							define_method(ref_to_define) do
								ref = ref_to_define
								@settings_values = {} if @settings_values.nil?
								@settings_values[ref] = self.get(ref) if !@settings_values[ref]
								return @settings_values[ref]
							end

							# Set method
							define_method((ref_to_define.to_s + "=").to_sym) do |value|
								ref = ref_to_define
								@settings_values = {} if @settings_values.nil?
								@settings_values[ref] = value
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
						self.settings.each do |setting_ref, setting_options|
							if setting_options[:category]
								if result[setting_options[:category]].nil?
									result[setting_options[:category]] = []
								end
								result[setting_options[:category]] << setting_ref
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
					attributes.each do |ref, value|
						self.send("#{ref}=", value)
					end
				end

				#
				# Store all modified values before save
				#
				def save
					@settings_values.each do |ref, value|
						self.set(ref, value)
					end
					return true
				end

			protected

				def get(ref)
					return RicSettings.setting_model.find_or_create_by(ref: ref.to_s).value
				end

				def set(ref, value)
					object = RicSettings.setting_model.find_or_create_by(ref: ref.to_s)
					object.value = value
					#object.kind = self.settings[ref.to_sym][:kind]
					#object.category = self.settings[ref.to_sym][:category]
					return object.save
				end

			end
		end
	end
end
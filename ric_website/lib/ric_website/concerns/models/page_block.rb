# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page block
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module PageBlock extend ActiveSupport::Concern

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
					# Relation to page
					#
					belongs_to :page, class_name: RicWebsite.page_model.to_s

					#
					# Relation to common subject
					#
					belongs_to :subject, polymorphic: true

					#
					# Ordering
					#
					enable_ordering

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Page must be present
					#
					validates_presence_of :page_id

					# *********************************************************
					# Subject
					# *********************************************************

					#
					# Subject must be binded after create
					#
					before_create :bind_subject_before_create

					#
					# Subject must be synchronized after save
					#
					after_save :synchronize_subject_after_save

					# *********************************************************
					# Key
					# *********************************************************

					#
					# Key enum
					#
					enum_column :key, config(:keys) if config(:enable_key)

					# *********************************************************
					# Text virtual attributes
					# *********************************************************

					#
					# Attribute writers, reades and localized columns
					#
					[:title, :content].each do |new_column|
						if RicWebsite.localization
							I18n.available_locales.each do |locale|
								attr_writer "#{new_column.to_s}_#{locale.to_s}".to_sym
								define_method("#{new_column.to_s}_#{locale.to_s}") do
									column = new_column
									value = instance_variable_get("@#{column.to_s}_#{locale.to_s}")
									value = self.subject.send("#{column.to_s}_#{locale.to_s}") if value.nil? && self.subject
									return value
								end
							end
							localized_column new_column
						else
							attr_writer new_column
							define_method(new_column) do
								column = new_column
								value = instance_variable_get("@#{column.to_s}")
								value = self.subject.send(column) if value.nil? && self.subject
								return value
							end
						end
					end

				end

				module ClassMethods

					#
					# Columns
					#
					def permitted_columns
						result = []
						[:title, :content].each do |column|
							if RicWebsite.localization
								I18n.available_locales.each do |locale|
									result << "#{column.to_s}_#{locale.to_s}".to_sym
								end
							else
								result << column
							end
						end
						[:key, :page_id].each do |column|
							result << column
						end
						return result
					end

				end

				# *************************************************************
				# Text virtual attributes
				# *************************************************************

				def content_formatted
					return self.subject.content_formatted if self.subject
					return ""
				end

			protected

				def bind_subject_before_create
					text = RicWebsite.text_model.new
					text.save
					self.subject = text
				end

				def synchronize_subject_after_save
					if self.subject
						[:title, :content].each do |column|
							if RicWebsite.localization
								I18n.available_locales.each do |locale|
									self.subject.send("#{column.to_s}_#{locale.to_s}=", self.send("#{column.to_s}_#{locale.to_s}"))
								end
							else
								self.subject.send("#{column.to_s}=", self.send(column))
							end
						end						
						self.subject.save
					end
				end

			end
		end
	end
end
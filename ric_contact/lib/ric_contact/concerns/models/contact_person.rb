# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact person
# *
# * Author: Matěj Outlý
# * Date  : 6. 4. 2016
# *
# *****************************************************************************

module RicContact
	module Concerns
		module Models
			module ContactPerson extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					enable_ordering

					# *********************************************************
					# Photo
					# *********************************************************

					if config(:photo_croppable) == true
						croppable_picture_column :photo, styles: { thumb: config(:photo_crop, :thumb), full: config(:photo_crop, :full) }
					else
						has_attached_file :photo, :styles => { thumb: config(:photo_crop, :thumb), full: config(:photo_crop, :full) }
						validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
					end

					# *********************************************************
					# Name
					# *********************************************************

					name_column :name, title: true

					# *********************************************************
					# Localization
					# *********************************************************

					if RicContact.localization
						localized_column :role
					end

				end

				module ClassMethods

					def permitted_columns
						result = []
						[:role].each do |column|
							if RicPartnership.localization
								I18n.available_locales.each do |locale|
									result << "#{column.to_s}_#{locale.to_s}".to_sym
								end
							else
								result << column
							end
						end
						[:phone, :email, :photo, :photo_crop_x, :photo_crop_y, :photo_crop_w, :photo_crop_h, :photo_perform_cropping].each do |column|
							result << column
						end
						[{:name => [:title, :firstname, :lastname]}].each do |column|
							result << column
						end
						return result
					end

				end

			end
		end
	end
end
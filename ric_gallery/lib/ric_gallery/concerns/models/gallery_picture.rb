# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Picture
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

module RicGallery
	module Concerns
		module Models
			module GalleryPicture extend ActiveSupport::Concern

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
					# Relation to gallery directory
					#
					belongs_to :gallery_directory, class_name: RicGallery.gallery_directory_model.to_s

					#
					# Ordering
					#
					enable_ordering

					# *********************************************************
					# Attachments
					# *********************************************************

					#
					# Picture
					#
					has_attached_file :picture, :styles => { :thumb => config(:picture_crop, :thumb), :full => config(:picture_crop, :full) }
					validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

					# *********************************************************
					# Localization
					# *********************************************************

					if RicGallery.localization
						localized_column :title
					end

				end

				module ClassMethods

					#
					# Columns
					#
					def permitted_columns
						result = []
						[:title].each do |column|
							if RicGallery.localization
								I18n.available_locales.each do |locale|
									result << "#{column.to_s}_#{locale.to_s}".to_sym
								end
							else
								result << column
							end
						end
						[:gallery_directory_id, :picture].each do |column|
							result << column
						end
						return result
					end

					# *********************************************************
					# Scopes
					# *********************************************************
					
					def without_directory
						where(gallery_directory_id: nil)						
					end

				end

			end
		end
	end
end
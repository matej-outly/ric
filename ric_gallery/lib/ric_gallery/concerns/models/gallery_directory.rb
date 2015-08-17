# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Directory
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicGallery
	module Concerns
		module Models
			module GalleryDirectory extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************
					
					#
					# Relation to gallery pictures
					#
					has_many :gallery_pictures, class_name: RicGallery.gallery_picture_model.to_s, dependent: :destroy

					#
					# Ordering
					#
					enable_hierarchical_ordering
					
					# *************************************************************************
					# Attachments
					# *************************************************************************

					#
					# Picture
					#
					has_attached_file :picture, :styles => { :thumb => config(:picture_crop, :thumb), :full => config(:picture_crop, :full) }
					validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
					
				end

				module ClassMethods

					# *********************************************************************
					# Scopes
					# *********************************************************************
					
				end

				# *************************************************************
				# Name with depth
				# *************************************************************

				def name_with_depth
					return (" - " * self.depth.to_i) + self.name.to_s
				end

				# *************************************************************
				# Parent
				# *************************************************************

				def available_parents
					RicGallery.gallery_directory_model.all.order(lft: :asc)
				end

			end
		end
	end
end
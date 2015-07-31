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
					# Relation to gallery images
					#
					has_many :gallery_images, class_name: RicGallery.gallery_image_model.to_s, dependent: :destroy

					#
					# Ordering
					#
					enable_hierarchical_ordering
					
					# *************************************************************************
					# Attachments
					# *************************************************************************

					#
					# Image
					#
					has_attached_file :image, :styles => { :thumb => "300x300>", :full => "1000x1000>" } # TODO configurable
					validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
					
				end

				module ClassMethods

					# *********************************************************************
					# Scopes
					# *********************************************************************
					
				end

			end
		end
	end
end
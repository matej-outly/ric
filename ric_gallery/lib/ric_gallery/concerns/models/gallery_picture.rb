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
					
					# *********************************************************************
					# Structure
					# *********************************************************************
					
					#
					# Relation to gallery directory
					#
					belongs_to :gallery_directory, class_name: RicGallery.gallery_directory_model.to_s

					#
					# Ordering
					#
					enable_ordering

					# *************************************************************************
					# Attachments
					# *************************************************************************

					#
					# Picture
					#
					has_attached_file :picture, :styles => { :thumb => "300x300>", :full => "1000x1000>" } # TODO configurable
					validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

				end

				module ClassMethods

					# *********************************************************************
					# Scopes
					# *********************************************************************
					
					def without_directory
						where(gallery_directory_id: nil)						
					end

				end

			end
		end
	end
end
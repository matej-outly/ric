# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicGallery
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

# Engines
require "ric_gallery/admin_engine"
require "ric_gallery/public_engine"

# Models
require 'ric_gallery/concerns/models/gallery_directory'
require 'ric_gallery/concerns/models/gallery_image'

module RicGallery

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Directory model
	#
	mattr_accessor :gallery_directory_model
	def self.gallery_directory_model
		if @@gallery_directory_model.nil?
			return RicGallery::GalleryDirectory
		else
			return @@gallery_directory_model.constantize
		end
	end

	#
	# Image model
	#
	mattr_accessor :gallery_image_model
	def self.gallery_image_model
		if @@gallery_image_model.nil?
			return RicGallery::GalleryImage
		else
			return @@gallery_image_model.constantize
		end
	end

end

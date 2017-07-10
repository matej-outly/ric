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
require "ric_gallery/concerns/models/gallery_directory"
require "ric_gallery/concerns/models/gallery_picture"

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
	# Default way to setup module
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# Directory model
	#
	mattr_accessor :gallery_directory_model
	def self.gallery_directory_model
		return @@gallery_directory_model.constantize
	end
	@@gallery_directory_model = "RicGallery::GalleryDirectory"

	#
	# Picture model
	#
	mattr_accessor :gallery_picture_model
	def self.gallery_picture_model
		return @@gallery_picture_model.constantize
	end
	@@gallery_picture_model = "RicGallery::GalleryPicture"

	#
	# Localization of some specific columns (names, titles, descriptions, etc.)
	#
	mattr_accessor :localization
	@@localization = false

	#
	# Class or object implementing actions_options, tabs_options, etc. can be set.
	#
	mattr_accessor :theme
	def self.theme
		if @@theme
			return @@theme.constantize if @@theme.is_a?(String)
			return @@theme
		end
		return OpenStruct.new
	end
	@@theme = nil
	
end

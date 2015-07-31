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
require 'ric_gallery/concerns/models/directory'
require 'ric_gallery/concerns/models/image'

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
	mattr_accessor :directory_model
	def self.directory_model
		if @@directory_model.nil?
			return RicGallery::Directory
		else
			return @@directory_model.constantize
		end
	end

	#
	# Image model
	#
	mattr_accessor :image_model
	def self.image_model
		if @@image_model.nil?
			return RicGallery::Image
		else
			return @@image_model.constantize
		end
	end

end

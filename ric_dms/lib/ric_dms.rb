# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# *
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

# Railtie
require 'ric_dms/railtie' if defined?(Rails)

# Engines
require "ric_dms/engine"

# Models
require 'ric_dms/concerns/models/document'
require 'ric_dms/concerns/models/document_folder'
require 'ric_dms/concerns/models/document_version'

# Helpers
require 'ric_dms/helpers/mime_type_helper'


module RicDms

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
	# Document model
	#
	mattr_accessor :document_model
	def self.document_model
		return @@document_model.constantize
	end
	@@document_model = "RicDms::Document"

	#
	# DocumentVersion model
	#
	mattr_accessor :document_version_model
	def self.document_version_model
		return @@document_version_model.constantize
	end
	@@document_version_model = "RicDms::DocumentVersion"

	#
	# DocumentFolder model
	#
	mattr_accessor :document_folder_model
	def self.document_folder_model
		return @@document_folder_model.constantize
	end
	@@document_folder_model = "RicDms::DocumentFolder"


end

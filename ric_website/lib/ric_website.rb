# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicWebsite
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Railtie
require "ric_website/railtie" if defined?(Rails)

# Engines
require "ric_website/admin_engine"
require "ric_website/public_engine"

# Models
require "ric_website/concerns/models/enum"
require "ric_website/concerns/models/field"
require "ric_website/concerns/models/field_value"
require "ric_website/concerns/models/node"
require "ric_website/concerns/models/node_attachment"
require "ric_website/concerns/models/node_picture"
require "ric_website/concerns/models/structure"

# Helpers
require "ric_website/helpers/node_helper"

module RicWebsite

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
	# Enum model
	#
	mattr_accessor :enum_model
	def self.enum_model
		return @@enum_model.constantize
	end
	@@enum_model = "RicWebsite::Enum"

	#
	# Structure model
	#
	mattr_accessor :structure_model
	def self.structure_model
		return @@structure_model.constantize
	end
	@@structure_model = "RicWebsite::Structure"

	#
	# Field model
	#
	mattr_accessor :field_model
	def self.field_model
		return @@field_model.constantize
	end
	@@field_model = "RicWebsite::Field"

	#
	# Field value model
	#
	mattr_accessor :field_value_model
	def self.field_value_model
		return @@field_value_model.constantize
	end
	@@field_value_model = "RicWebsite::FieldValue"

	#
	# Node model
	#
	mattr_accessor :node_model
	def self.node_model
		return @@node_model.constantize
	end
	@@node_model = "RicWebsite::Node"

	#
	# Node attachment model
	#
	mattr_accessor :node_attachment_model
	def self.node_attachment_model
		return @@node_attachment_model.constantize
	end
	@@node_attachment_model = "RicWebsite::NodeAttachment"

	#
	# Enable node pictures subsystem
	#
	mattr_accessor :enable_node_pictures
	@@enable_node_pictures = false

	#
	# Node picture model
	#
	mattr_accessor :node_picture_model
	def self.node_picture_model
		return @@node_picture_model.constantize
	end
	@@node_picture_model = "RicWebsite::NodePicture"

	#
	# Localization of some specific columns (titles, contents, descriptions, etc.)
	#
	mattr_accessor :localization
	@@localization = false

end

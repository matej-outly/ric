# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicAttachment
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Engines
require "ric_attachment/engine"

# Models
require "ric_attachment/concerns/models/attachment"
require "ric_attachment/concerns/models/slugged_attachment"

module RicAttachment

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
	# Attachment model
	#
	mattr_accessor :attachment_model
	def self.attachment_model
		return @@attachment_model.constantize
	end
	@@attachment_model = "RicAttachment::Attachment"
	
	#
	# Enable slugs subsystem (RicUrl must be used)
	#
	mattr_accessor :enable_slugs
	@@enable_slugs = true

	#
	# Enabled editors
	#
	mattr_accessor :editors
	@@editors = []

end

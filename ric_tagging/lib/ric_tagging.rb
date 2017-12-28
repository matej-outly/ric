# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicTagging
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

# Engines
require "ric_tagging/engine"

# Models
require "ric_tagging/concerns/models/tag"

module RicTagging

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
	# Tag model
	#
	mattr_accessor :tag_model
	def self.tag_model
		return @@tag_model.constantize
	end
	@@tag_model = "RicTagging::Tag"

end

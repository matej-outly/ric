# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPlugin
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

# Engines
require "ric_plugin/engine"

# Models
require "ric_plugin/concerns/models/plugin"
require "ric_plugin/concerns/models/plugin_relation"
require "ric_plugin/concerns/models/subject"

module RicPlugin

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Default way to setup plugin
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************
	
	#
	# Plugin model
	#
	mattr_accessor :plugin_model
	def self.plugin_model
		return @@plugin_model.constantize
	end
	@@plugin_model = "RicPlugin::Plugin"

	#
	# Plugin relation model
	#
	mattr_accessor :plugin_relation_model
	def self.plugin_relation_model
		return @@plugin_relation_model.constantize
	end
	@@plugin_relation_model = "RicPlugin::PluginRelation"

	#
	# Subject model
	#
	mattr_accessor :subject_model
	def self.subject_model
		return @@subject_model.constantize
	end
	@@subject_model = nil

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

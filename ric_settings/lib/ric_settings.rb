# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicSettings
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Railtie
require 'ric_settings/railtie' if defined?(Rails)

# Engines
require "ric_settings/admin_engine"

# Models
require 'ric_settings/concerns/models/setting'
require 'ric_settings/concerns/models/settings_collection'

# Helpers
require 'ric_settings/helpers/setting_helper'

module RicSettings

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
	# Setting model
	#
	mattr_accessor :setting_model
	def self.setting_model
		return @@setting_model.constantize
	end
	@@setting_model = "RicSettings::Setting"

	#
	# Settings collection model
	#
	mattr_accessor :settings_collection_model
	def self.settings_collection_model
		return @@settings_collection_model.constantize
	end
	@@settings_collection_model = "RicSettings::SettingsCollection"

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

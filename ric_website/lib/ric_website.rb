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
require 'ric_website/railtie' if defined?(Rails)

# Engines
require "ric_website/admin_engine"
require "ric_website/public_engine"

# Middlewares
require 'ric_website/middlewares/locale'
require 'ric_website/middlewares/slug'

# Models
require 'ric_website/concerns/models/page'
require 'ric_website/concerns/models/page_block'
require 'ric_website/concerns/models/menu'
require 'ric_website/concerns/models/text'
require 'ric_website/concerns/models/text_attachment'
require 'ric_website/concerns/models/slug'
require 'ric_website/concerns/models/setting'
require 'ric_website/concerns/models/settings_collection'

# Helpers
require 'ric_website/helpers/locale_helper'
require 'ric_website/helpers/page_helper'
require 'ric_website/helpers/slug_helper'
require 'ric_website/helpers/setting_helper'

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
	# Text model
	#
	mattr_accessor :text_model
	def self.text_model
		return @@text_model.constantize
	end
	@@text_model = "RicWebsite::Text"

	#
	# Text attachment model
	#
	mattr_accessor :text_attachment_model
	def self.text_attachment_model
		return @@text_attachment_model.constantize
	end
	@@text_attachment_model = "RicWebsite::TextAttachment"

	#
	# Page model
	#
	mattr_accessor :page_model
	def self.page_model
		return @@page_model.constantize
	end
	@@page_model = "RicWebsite::Page"

	#
	# Page block model
	#
	mattr_accessor :page_block_model
	def self.page_block_model
		return @@page_block_model.constantize
	end
	@@page_block_model = "RicWebsite::PageBlock"

	#
	# Slug model
	#
	mattr_accessor :slug_model
	def self.slug_model
		return @@slug_model.constantize
	end
	@@slug_model = "RicWebsite::Slug"

	#
	# Enable settings subsystem
	#
	mattr_accessor :enable_settings
	@@enable_settings = true

	#
	# Setting model
	#
	mattr_accessor :setting_model
	def self.setting_model
		return @@setting_model.constantize
	end
	@@setting_model = "RicWebsite::Setting"

	#
	# Settings collection model
	#
	mattr_accessor :settings_collection_model
	def self.settings_collection_model
		return @@settings_collection_model.constantize
	end
	@@settings_collection_model = "RicWebsite::SettingsCollection"

	#
	# Enable menus subsystem
	#
	mattr_accessor :enable_menus
	@@enable_menus = true

	#
	# Menu model
	#
	mattr_accessor :menu_model
	def self.menu_model
		return @@menu_model.constantize
	end
	@@menu_model = "RicWebsite::Menu"

	#
	# Localization of some specific columns (titles, contents, descriptions, etc.)
	#
	mattr_accessor :localized
	@@localized = false

end

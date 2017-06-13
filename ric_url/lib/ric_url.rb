# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicUrl
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Railtie
require "ric_url/railtie" if defined?(Rails)

# Engines
require "ric_url/admin_engine"

# Middlewares
require "ric_url/middlewares/locale"
require "ric_url/middlewares/slug"

# Models
require "ric_url/concerns/models/slug"
require "ric_url/concerns/models/slug_generator"
require "ric_url/concerns/models/hierarchical_slug_generator"

# Helpers
require "ric_url/helpers/locale_helper"
require "ric_url/helpers/slug_helper"

module RicUrl

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
	# Disable unaccent extension in SQL queries
	#
	mattr_accessor :disable_unaccent
	@@disable_unaccent = false

	#
	# Slug model
	#
	mattr_accessor :slug_model
	def self.slug_model
		return @@slug_model.constantize
	end
	@@slug_model = "RicUrl::Slug"

	#
	# Enable slugs subsystem
	#
	mattr_accessor :enable_slugs
	@@enable_slugs = true

	#
	# Enable localization subsystem
	#
	mattr_accessor :enable_locales
	@@enable_locales = true

	#
	# Default locale is hidden in URL by default. This feature can be disabled 
	# by setting true to this option.
	#
	# Example: Default locale is "cs" and all available locales are "cs" and 
	# "en". For false value URLs looks like this:
	# - /fotogalerie
	# - /en/photogallery
	# For true value URLs looks like this:
	# - /cs/fotogalerie
	# - /en/photogallery
	#
	mattr_accessor :disable_default_locale
	@@disable_default_locale = false

	#
	# Use filter column in slug records?
	#
	# Filter column can be used for filtering subset of slugs valid for some 
	# specific application variant (different domain or subdomain) in case 
	# these variants share database.
	#
	mattr_accessor :use_filter
	@@use_filter = false

	#
	# Use this string to filter slugs valid for this application
	#
	mattr_accessor :current_app_filter
	@@current_app_filter = nil

	#
	# Map of available filters => URL to be created. Used for linking to 
	# different application variant (different domain).
	#
	mattr_accessor :available_filter_urls
	@@available_filter_urls = {}

	#
	# If enabled translations are downcased before lookup. It means that
	# translated URLs like /fotogalerie, /Fotogalerie and /FOTOGALERIE points 
	# to the same original URL.
	#
	mattr_accessor :downcase_translations
	@@downcase_translations = false

end

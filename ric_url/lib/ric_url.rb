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
require "ric_url/engine"

# Middlewares
require "ric_url/middlewares/locale"
require "ric_url/middlewares/slug"

# Models
require "ric_url/concerns/models/slug"
require "ric_url/concerns/models/slug_generator"
require "ric_url/concerns/models/hierarchical_slug_generator"

# Helpers
require "ric_url/helpers/url_helper"

module RicUrl

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Interface
	# *************************************************************************

	def self.disassemble(path)
		# TODO work correctly with http:// and https:// links

		# Match locale from path
		match = /^\/(#{I18n.available_locales.join("|")})\//.match(path + "/")
		if match
			locale = match[1].to_sym
		else
			locale = nil
		end

		# Remove locale from path
		if locale
			path = path[(1+locale.to_s.length)..-1]
		end

		# Root
		if path.blank?
			path = "/"
		end
		
		return [locale, path]
	end

	def self.assemble(locale, path)
		if locale && (RicUrl.disable_default_locale || (I18n.default_locale.to_sym != locale.to_sym))
			if path == "/"
				path = "/" + locale.to_s
			elsif path.starts_with?("http")
				split1 = path.split("//")
				split2 = split1[1].to_s.split("/")
				split1[1] = split2.insert(1, locale.to_s).join("/")
				path = split1.join("//")
			else
				path = "/" + locale.to_s + path 
			end
		end
		return path
	end

	def self.localify(path)
		return path if path == "#"

		# Match locale from path
		locale, path = self.disassemble(path)

		# Take current locale if path locale not defined
		if locale.nil?
			locale = I18n.locale
		end

		# Assemble back into path with locale
		path = self.assemble(locale, path)

		return path
	end

	def self.slugify(path)

		# Match locale from path
		locale, original = self.disassemble(path)

		# Translate from original
		tmp_uri = URI.parse(original)
		tmp_path = RicUrl.slug_model.original_to_translation((locale ? locale : I18n.default_locale), tmp_uri.path)
		if tmp_path
			tmp_uri.path = tmp_path
			translation = tmp_uri.to_s
		else
			translation = original
		end

		# Add locale if defined
		translation = self.assemble(locale, translation)
		
		return translation
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
	# By default, headers sent from browser are checked and default locale is 
	# set automatically according to browser language (if possible). This 
	# feature can be disable by setting true to this option.
	#
	mattr_accessor :disable_browser_locale
	@@disable_browser_locale = false

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

	#
	# Slugs which are by loaded to translation tables by default without necessity
	# to generate it in generators.
	#
	mattr_accessor :static_slugs
	@@static_slugs = []


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

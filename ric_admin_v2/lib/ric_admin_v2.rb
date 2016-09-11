# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicAdmin
# *
# * Author: Matěj Outlý
# * Date  : 27. 4. 2015
# *
# *****************************************************************************

require "ric_admin/engine"

module RicAdmin

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
	# Screen CSS layout
	#
	mattr_accessor :css_layout
	@@css_layout = "application"

	#
	# JS layout
	#
	mattr_accessor :js_layout
	@@js_layout = "application"

	#
	# Title
	#
	mattr_accessor :title
	@@title = "Administrace"

	#
	# Header logo URL and image
	#
	mattr_accessor :header_logo_url
	@@header_logo_url = "main_app.root_path"
	mattr_accessor :header_logo_image
	@@header_logo_image = "ric_admin/header_logo.png"

	#
	# Client info
	#
	mattr_accessor :client_name
	@@client_name = "Klient"
	mattr_accessor :client_year
	@@client_year = 2016
	mattr_accessor :client_url
	@@client_url = "http://www.klient.cz"
	mattr_accessor :client_image
	@@client_image = "ric_admin/footer_logo_client.png"

	#
	# Developer info
	#
	mattr_accessor :developer_name
	@@developer_name = "Clockstar s.r.o."
	mattr_accessor :developer_year
	@@developer_year = 2012
	mattr_accessor :developer_url
	@@developer_url = "http://www.clockstar.cz"
	mattr_accessor :developer_image
	@@developer_image = "ric_admin/footer_logo_clockstar.png"

	#
	# Footer menu
	#
	mattr_accessor :footer_menu
	@@footer_menu = [
		{
			label: "headers.ric_admin.public.terms",
			url: "ric_admin.public_terms_path"
		},
		{
			label: "headers.ric_admin.public.accessibility",
			url: "ric_admin.public_accessibility_path"
		},
		{
			label: "headers.ric_admin.public.help",
			url: "ric_admin.public_help_path"
		},
		{
			label: "headers.ric_admin.public.contact",
			url: "ric_admin.public_contact_path"
		}
	]

	#
	# Header menu
	#
	mattr_accessor :header_menu
	@@header_menu = []
	
end

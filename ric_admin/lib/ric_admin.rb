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
	# Print CSS layout
	#
	mattr_accessor :print_css_layout
	@@print_css_layout = "print"

	#
	# JS layout
	#
	mattr_accessor :js_layout
	@@js_layout = "application"

end

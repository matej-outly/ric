# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPortal
# *
# * Author: Matěj Outlý
# * Date  : 27. 4. 2015
# *
# *****************************************************************************

require "ric_portal/engine"

module RicPortal

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

end

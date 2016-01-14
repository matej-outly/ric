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
	# Screen CSS layout
	#
	mattr_accessor :css_layout
	def self.css_layout
		if @@css_layout.nil?
			return "application"
		else
			return @@css_layout
		end
	end

	#
	# JS layout
	#
	mattr_accessor :js_layout
	def self.js_layout
		if @@js_layout.nil?
			return "application"
		else
			return @@js_layout
		end
	end

end

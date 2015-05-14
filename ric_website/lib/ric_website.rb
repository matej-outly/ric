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

# Engines
require "ric_website/admin_engine"
require "ric_website/public_engine"

# Models
require 'ric_website/concerns/models/text'

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
	# Text model
	#
	mattr_accessor :text_model
	def self.text_model
		if @@text_model.nil?
			return RicWebsite::Text
		else
			return @@text_model.constantize
		end
	end

end

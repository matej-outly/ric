# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicTagging
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

require "ric_tagging/engine"

module RicTagging

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Tag model
	#
	mattr_accessor :tag_model
	def self.tag_model
		if @@tag_model.nil?
			return RicTagging::Tag
		else
			return @@tag_model.constantize
		end
	end

end

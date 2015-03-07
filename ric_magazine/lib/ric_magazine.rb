# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicMagazine
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

require "ric_magazine/engine"

module RicMagazine

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Magazine model
	#
	mattr_accessor :article_model
	def self.article_model
		if @@article_model.nil?
			return RicMagazine::Article
		else
			return @@article_model.constantize
		end
	end

end

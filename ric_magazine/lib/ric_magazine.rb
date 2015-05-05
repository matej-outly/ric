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

# Engines
require "ric_magazine/admin_engine"
require "ric_magazine/public_engine"

# Models
require 'ric_magazine/concerns/models/article'

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

	#
	# User model
	#
	mattr_accessor :user_model
	def self.user_model
		if @@user_model.nil?
			raise 'Please define user model'
		else
			return @@user_model.constantize
		end
	end

end

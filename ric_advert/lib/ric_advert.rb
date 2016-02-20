# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicAdvert
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

# Engines
require "ric_advert/admin_engine"
require "ric_advert/observer_engine"
require "ric_advert/public_engine"

# Models
require 'ric_advert/concerns/models/advertiser'
require 'ric_advert/concerns/models/banner'
require 'ric_advert/concerns/models/banner_statistic'

module RicAdvert

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
	# Advertiser model
	#
	mattr_accessor :advertiser_model
	def self.advertiser_model
		return @@advertiser_model.constantize
	end
	@@advertiser_model = "RicAdvert::Advertiser"

	#
	# Banner model
	#
	mattr_accessor :banner_model
	def self.banner_model
		return @@banner_model.constantize
	end
	@@banner_model = "RicAdvert::Banner"

	#
	# Banner statistic model
	#
	mattr_accessor :banner_statistic_model
	def self.banner_statistic_model
		return @@banner_statistic_model.constantize
	end
	@@banner_statistic_model = "RicAdvert::BannerStatistic"

end

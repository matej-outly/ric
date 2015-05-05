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
	# Advertiser model
	#
	mattr_accessor :advertiser_model
	def self.advertiser_model
		if @@advertiser_model.nil?
			return RicAdvert::Advertiser
		else
			return @@advertiser_model.constantize
		end
	end

	#
	# Banner model
	#
	mattr_accessor :banner_model
	def self.banner_model
		if @@banner_model.nil?
			return RicAdvert::Banner
		else
			return @@banner_model.constantize
		end
	end

	#
	# Banner statistic model
	#
	mattr_accessor :banner_statistic_model
	def self.banner_statistic_model
		if @@banner_statistic_model.nil?
			return RicAdvert::BannerStatistic
		else
			return @@banner_statistic_model.constantize
		end
	end

end
